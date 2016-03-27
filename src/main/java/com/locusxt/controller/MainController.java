package com.locusxt.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by zhuting on 15/10/14.
 */
@Controller
public class MainController {


    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index() {
        return "index3";
    }

    @RequestMapping(value = "/flowchart", method = RequestMethod.GET)
    public String flow_chart() {
        return "flow2";
    }
}
