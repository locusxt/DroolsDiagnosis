package com.locusxt;

/**
 * Created by zhuting on 16/3/18.
 */
import org.kie.api.KieBase;
import org.kie.api.KieServices;
import org.kie.api.definition.type.FactType;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
//import org.omg.CORBA.Object;

/**
 * Created by zhuting on 16/3/6.
 */
public class MyTest {
    public static final void main(String[] args) {
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
            stateType.set(sta, "text", "start");

            FactType acheType = kbase.getFactType("rules", "Ache");
            Object ache = acheType.newInstance();
            acheType.set(ache, "position", "venter superior");
            acheType.set(ache, "duration_", 10);

            FactType lftType = kbase.getFactType("rules", "LFTs");
            Object lfts = lftType.newInstance();
            lftType.set(lfts, "state", "Normal");

            FactType lipsType = kbase.getFactType("rules", "Lipase");
            Object lips = lipsType.newInstance();
            lipsType.set(lips, "state", "Normal");

            FactType uiType = kbase.getFactType("rules", "UltrasonicInspection");
            Object ui = uiType.newInstance();
            uiType.set(ui, "result_", "positive");


//            Message message = new Message();
//            message.setMessage("Hello World");
//            message.setStatus(Message.HELLO);
            kSession.insert(sta);
            kSession.insert(ache);
            kSession.insert(lfts);kSession.insert(lips);
            kSession.insert(ui);
            kSession.fireAllRules();
            System.out.println("end " + stateType.get(sta, "text"));
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
}
