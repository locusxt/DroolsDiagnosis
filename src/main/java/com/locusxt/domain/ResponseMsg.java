package com.locusxt.domain;

/**
 * Created by zhuting on 16/3/18.
 */
public class ResponseMsg {
    String msg;
    public void setMsg(String msg){this.msg = msg;}

    public String getMsg(){return this.msg;}

    public ResponseMsg(String msg){
        this.msg = msg;
    }
}
