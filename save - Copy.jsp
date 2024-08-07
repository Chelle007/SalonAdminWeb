<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}                    
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
        System.out.println(Gen.gettable(request.getParameter("tp"))+","+Gen.gettable(request.getParameter("id"))+",act="+Gen.gettable(request.getParameter("act")));
        
       //parameter oper=del (delete),oper=edit=update
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
            System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        
      	java.sql.Connection conn = connMgr.getConnection("db2");        
        String msg="";
        if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("CUSTOMER")||Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SHIPPER")||Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("COSIGNEE")){    //
          if(Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")){//
                String cd="";
                java.util.Vector d=(java.util.Vector)ses.getAttribute("CODE");
                for(int m=0;m<d.size();m+=3){
                    if(gen.gettable(request.getParameter("id")).equalsIgnoreCase(gen.gettable(d.get(m)))){
                        cd=gen.gettable(d.get(m+1)).trim();
                        break;
                    }
                }
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"DELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),cd});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"DELETE",cd});
          }else{      
            if(Gen.gettable(request.getParameter("code")).length()>0){//
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"UPDATE",new String[]{Gen.gettable(request.getParameter("description")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"UPDATE",gen.gettable(request.getParameter("code"))});
            }else{             //membername,gender,membertype,donaturtype,memberphone,nowa,[PASSWORD],UpLineMemberid,MEMBERID
                String ID="";
                java.util.Vector membx=new java.util.Vector();//sgen.getDataQuery(conn,"CODE"+Gen.gettable(request.getParameter("tp"))+"MAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SHIPPER")){
                    membx=sgen.getDataQuery(conn,"CODESHIPPERMAX",new String[0]);                
                }else{
                    membx=sgen.getDataQuery(conn,"CODE"+Gen.gettable(request.getParameter("tp"))+"MAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                }
  //              System.out.println("tp="+Gen.gettable(request.getParameter("tp"))+","+membx.size());
                if(membx.size()>0){
                    int len=Gen.gettable(membx.get(0)).trim().length();
                    int x=1;
                    if(len>0) x=Gen.getInt(Gen.gettable(membx.get(0)).trim().substring(len-3,len))+1;
                    String pref=Gen.gettable(membx.get(0)).trim().substring(0,len-3);
                    String xx=x+"";
                    for(int xt=xx.length();xt<3;xt++)ID=ID+"0"; 
                    ID=pref+ID+x;
                }else{
                    ID=ID+"0001";
                }
//                System.out.println("ID==>"+ID);
                  msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"ADD",new String[]{Gen.gettable(request.getParameter("description")),gen.gettable(ses.getAttribute("TxtErcode")),ID});
                  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"ADD",ID});
            }
          }           
     }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("VENDOR")||Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("BILLTO")){
          if(Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")){//
                String cd="";
                java.util.Vector d=(java.util.Vector)ses.getAttribute("CODE");
                for(int m=0;m<d.size();m+=3){
                    if(gen.gettable(request.getParameter("id")).equalsIgnoreCase(gen.gettable(d.get(m)))){
                        cd=gen.gettable(d.get(m+1)).trim();
                        break;
                    }
                }
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"DELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),cd});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"DELETE",cd});
          }else{      
            if(Gen.gettable(request.getParameter("code")).length()>0){//
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"NEWUPDATE",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("inflag")),Gen.gettable(request.getParameter("seq")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"NEWUPDATE",gen.gettable(request.getParameter("code"))});
            }else{             //membername,gender,membertype,donaturtype,memberphone,nowa,[PASSWORD],UpLineMemberid,MEMBERID
                String ID="";
                java.util.Vector membx=sgen.getDataQuery(conn,"CODE"+Gen.gettable(request.getParameter("tp"))+"MAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
    //            System.out.println("tp="+Gen.gettable(request.getParameter("tp"))+","+membx.size());
                if(membx.size()>0){
                    int len=Gen.gettable(membx.get(0)).trim().length();
                    int x=1;
                    if(len>0) x=Gen.getInt(Gen.gettable(membx.get(0)).trim().substring(len-3,len))+1;
                    String pref=Gen.gettable(membx.get(0)).trim().substring(0,len-3);
                    String xx=x+"";
                    for(int xt=xx.length();xt<3;xt++)ID=ID+"0"; 
                    ID=pref+ID+x;
                }else{
                    ID=ID+"0001";
                }
                System.out.println("ID==>"+ID);
                  msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"NEWADD",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("inflag")),Gen.gettable(request.getParameter("seq")),gen.gettable(ses.getAttribute("TxtErcode")),ID});
                  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"NEWADD",ID});
            }
          }                
     }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("ACCOUNT")){
          if(Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")){//
                String cd="";
                java.util.Vector d=(java.util.Vector)ses.getAttribute("ACCOUNT");
                for(int m=0;m<d.size();m+=5){
                    if(gen.gettable(request.getParameter("id")).equalsIgnoreCase(gen.gettable(d.get(m)))){
                        cd=gen.gettable(d.get(m+2)).trim();
                        break;
                    }
                }
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"DELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),cd});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"DELETE",cd});
          }else{      
            if(!Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("add")){//
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"UPDATE",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("parent")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"UPDATE",gen.gettable(request.getParameter("code"))});
            }else{           
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"ADD",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("parent")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"ADD",gen.gettable(request.getParameter("code"))});
            }
          }           
     }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("BANK")){
          if(Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")){//
                String cd="";
                java.util.Vector d=(java.util.Vector)ses.getAttribute("CODE");
                for(int m=0;m<d.size();m+=5){
                    if(gen.gettable(request.getParameter("id")).equalsIgnoreCase(gen.gettable(d.get(m)))){
                        cd=gen.gettable(d.get(m+2)).trim();
                        break;
                    }
                }
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"DELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),cd});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"DELETE",cd});
          }else{      
            if(!Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("add")){//
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"UPDATE",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("curr")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"UPDATE",gen.gettable(request.getParameter("code"))});
            }else{           
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"ADD",new String[]{Gen.gettable(request.getParameter("description")),Gen.gettable(request.getParameter("curr")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"ADD",gen.gettable(request.getParameter("code"))});
            }
          }           
     }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("EXCRATE")){
          if(Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")){//
                String cd="";
                java.util.Vector d=(java.util.Vector)ses.getAttribute("CODE");
                for(int m=0;m<d.size();m+=5){
                    if(gen.gettable(request.getParameter("id")).equalsIgnoreCase(gen.gettable(d.get(m)))){
                        cd=gen.gettable(d.get(m+2)).trim();
                        break;
                    }
                }
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"DELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),cd});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"DELETE",cd});
          }else{      
            if(!Gen.gettable(request.getParameter("oper")).equalsIgnoreCase("add")){//
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"UPDATE",new String[]{Gen.gettable(request.getParameter("cur")),Gen.gettable(request.getParameter("rate")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"UPDATE",gen.gettable(request.getParameter("code"))});
            }else{           
                msg=sgen.update(conn,Gen.gettable(request.getParameter("tp"))+"ADD",new String[]{Gen.gettable(request.getParameter("cur")),Gen.gettable(request.getParameter("rate")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("code"))});
                  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),Gen.gettable(request.getParameter("tp"))+"ADD",gen.gettable(request.getParameter("code"))});
            }
          }           
     }
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>

