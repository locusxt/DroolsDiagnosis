package com.locusxt.controller;

import com.locusxt.MyTest;
import com.locusxt.domain.Item;
import com.locusxt.domain.ResponseMsg;
import org.kie.api.KieBase;
import org.kie.api.KieServices;
import org.kie.api.definition.type.FactType;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List ;


/**
 * Created by zhuting on 16/3/18.
 */

@Controller
@RequestMapping("/test")
public class TestController {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String diagnosis(ModelMap model) {
        return "test";
    }

    @RequestMapping(value = "/ajax/test", method = RequestMethod.POST)
    public @ResponseBody ResponseMsg getItems(@RequestBody List<Item> items){
        for (int i = 0; i < items.size(); ++i){
            System.out.println(items.get(i).toString());
        }
        String res = "";
        try {
            // load up the knowledge base
            KieServices ks = KieServices.Factory.get();
            KieContainer kContainer = ks.getKieClasspathContainer();
            KieSession kSession = kContainer.newKieSession("ksession-rules");

            KieBase kbase = kContainer.getKieBase("rules");
            // go !
            FactType stateType = kbase.getFactType( "rules", "State" );
            Object sta = stateType.newInstance();
            stateType.set(sta, "id", -1);
            stateType.set(sta, "text", "None");
            kSession.insert(sta);


            for (int i = 0; i < items.size(); ++i){
                String i_name = items.get(i).getName();
                String[] i_keys = items.get(i).getKeyList();
                String[] i_values = items.get(i).getValueList();
                String[] i_types = items.get(i).getTypeList();

                FactType tmpType = kbase.getFactType( "rules", i_name );
                Object tmpObj = tmpType.newInstance();
                for (int j = 0; j < i_keys.length; ++j){
                    System.out.println(i_types[j]);
                    if (i_types[j].equals("int")) {
//                        System.out.println("hhh");
                        tmpType.set(tmpObj, i_keys[j], Integer.parseInt(i_values[j]));
                    }
                    else
                        tmpType.set(tmpObj, i_keys[j], i_values[j]);

                }
                kSession.insert(tmpObj);

            }
//            Message message = new Message();
//            message.setMessage("Hello World");
//            message.setStatus(Message.HELLO);

            kSession.fireAllRules();
            System.out.println("end " + stateType.get(sta, "text"));
            res = "" +  stateType.get(sta, "text");
        } catch (Throwable t) {
            t.printStackTrace();
        }
//        String[] args = new String[3];
//        MyTest.main(args);
        return new ResponseMsg(res);
    }
}
