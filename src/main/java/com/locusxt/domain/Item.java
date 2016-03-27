package com.locusxt.domain;

/**
 * Created by zhuting on 16/3/18.
 */
public class Item {
    String name;
    String keyList[];
    String valueList[];
    String typeList[];
    public void setName(String name) {this.name = name;}

    public String getName() {return this.name;}

    public void setKeyList(String keyList[]){
        this.keyList = keyList;
    }

    public String[] getKeyList(){
        return this.keyList;
    }

    public void setValueList(String valueList[]) {this.valueList = valueList;}

    public String[] getValueList() {return this.valueList;}

    public void setTypeList(String typeList[]){
        this.typeList = typeList;
    }

    public String[] getTypeList(){
        return this.typeList;
    }

    public String toString(){
        int len = keyList.length;
        String str = this.name + " ";
        for (int i = 0; i < len; ++i){
            str += keyList[i] + "(" + typeList[i] + ")" + ":";
            str += valueList[i] + " ";
        }
        return str;
    }
}
