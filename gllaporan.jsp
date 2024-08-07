<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="Static &amp; Dynamic Tables" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->

		<!-- text fonts -->
		<link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="assets/css/ace-part2.min.css" class="ace-main-stylesheet" />
		<![endif]-->
		<link rel="stylesheet" href="assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="assets/css/ace-rtl.min.css" />

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="assets/css/ace-ie.min.css" />
		<![endif]-->

		<!-- inline styles related to this page -->

		<!-- ace settings handler -->
		<script src="assets/js/ace-extra.min.js"></script>

		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

		<!--[if lte IE 8]>
		<script src="assets/js/html5shiv.min.js"></script>
		<script src="assets/js/respond.min.js"></script>
		<![endif]-->
	</head>
<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}     
              
        com.ysoft.General gen = new com.ysoft.General();
        com.ysoft.General Gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
        String user=gen.gettable(ses.getAttribute("User"));
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.QueryClass queryclass = new com.ysoft.QueryClass();
          String title="Data Donatur";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode"))};
           
          java.util.Vector data=new java.util.Vector();    
          java.util.Vector datadetail= new java.util.Vector();
          java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         String S1=gen.gettable(request.getParameter("S1"));
         String S2=gen.gettable(request.getParameter("S2"));
         String crntyear="",crntmonth="";
         double stot1=0,stot2=0;
         String mth=crntmonth;
         if(userdef.size()>0){
            crntmonth=gen.gettable(userdef.get(0));
            crntyear=gen.gettable(userdef.get(1));
            String prevy=crntyear,prevm=(gen.getInt(crntmonth)-1)+"";
            mth=crntmonth;
            if(mth.length()==1)mth="0"+mth;
             
            if(gen.getInt(crntmonth)==1){
              prevy=(gen.getInt(prevy)-1)+"";
              prevm="12";
            }
            if(request.getParameter("S1")==null){
              S1=prevm;
              S2=prevy;
            }
         }
         //System.out.println("S1="+S1+",S2="+S2);
         String[] judul=new String[]{"ACCOUNT","AMOUNT"};
          java.util.Vector combo1=new java.util.Vector();
          combo1.addElement("1");
          combo1.addElement("2");
          combo1.addElement("3");
          combo1.addElement("4");
          combo1.addElement("5");
          combo1.addElement("6");
          combo1.addElement("7");
          combo1.addElement("8");
          combo1.addElement("9");
          combo1.addElement("10");
          combo1.addElement("11");
          combo1.addElement("12");
          java.util.Vector combo2=sgen.getDataQuery(conn,"GLYEAR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          if(combo2.size()==0){ 
            combo2.addElement(S2);
          }
          String tpx=gen.gettable(request.getParameter("S3"));
          if(tpx.equalsIgnoreCase("BS") || request.getParameter("S3")==null){       //
            title="Balance Sheet";        
            String trx=sgen.getLastDayofMonth(gen.getInt(S1),gen.getInt(S2))+"-"+S1+"-"+S2;
            java.util.Vector vkrate=sgen.getDataQuery(conn,"LISTRATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx});
            double rateusd=0;
            double ratesgd=0;
            for(int ms=0;ms<vkrate.size();ms+=2){
                if(gen.gettable(vkrate.get(ms)).trim().equalsIgnoreCase("SGD")){
                    ratesgd=gen.getformatdouble(vkrate.get(ms+1));
                }
                if(gen.gettable(vkrate.get(ms)).trim().equalsIgnoreCase("USD")){
                    rateusd=gen.getformatdouble(vkrate.get(ms+1));
                }
                
            }
           // System.out.println(trx+"rateusd="+rateusd+",ratesgd="+ratesgd);
            double tot1=0,tot2=0;
            java.util.Vector ex=new java.util.Vector();
            java.util.Vector parent=sgen.getDataQuery(conn,"REPBS1",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode"))});
            for(int s=0;s<parent.size();s+=3){
                String p_acct=gen.gettable(parent.get(s));
                if(p_acct.equalsIgnoreCase("30000")){
                    data.addElement("<b>NET ASSETS >>></b>");
                    double a=tot1-tot2;                
                    data.addElement(a+"");
                }
                data.addElement(p_acct+"("+gen.gettable(parent.get(s+1)).trim()+")");                
                data.addElement(gen.gettable(parent.get(s+2)));
                ex.addElement(p_acct+"("+gen.gettable(parent.get(s+1)).trim()+")");                
                ex.addElement(gen.gettable(parent.get(s+2)));
                double totp=gen.getformatdouble(parent.get(s+2));
                java.util.Vector anak=sgen.getDataQuery(conn,"REPBS2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p_acct});                
                for(int ss=0;ss<anak.size();ss+=3){
                    String p2_acct=gen.gettable(anak.get(ss));
                    double totp2=gen.getformatdouble(anak.get(ss+2));                        
                    if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                        if(gen.gettable(anak.get(ss+1)).trim().indexOf("SGD")>0 && gen.gettable(anak.get(ss+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                            totp2=ratesgd*totp2;                            
                        }
                        if(gen.gettable(anak.get(ss+1)).trim().indexOf("USD")>0 && gen.gettable(anak.get(ss+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                            totp2=rateusd*totp2;
                        }
                    }
                    //if(p2_acct.startsWith("122")){
                       // totp2=totp2*-1;
                    //}
                    java.util.Vector anak1=sgen.getDataQuery(conn,"REPBS2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p2_acct});
                    if(totp2!=0 || anak1.size()>0){
                        data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;"+p2_acct+"("+gen.gettable(anak.get(ss+1)).trim()+")");                    
                        data.addElement(totp2+"");
                        ex.addElement("             "+p2_acct+"("+gen.gettable(anak.get(ss+1)).trim()+")");                    
                        ex.addElement(totp2+"");
                    }
                    for(int sss=0;sss<anak1.size();sss+=3){
                        String p3_acct=gen.gettable(anak1.get(sss));
                        double totp3=gen.getformatdouble(anak1.get(sss+2));                        
                        java.util.Vector anak2=sgen.getDataQuery(conn,"REPBS2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p3_acct});
                        if(anak2.size()>0 || totp3!=0){
                            
                            if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                if(gen.gettable(anak1.get(sss+1)).trim().indexOf("SGD")>0 && gen.gettable(anak1.get(sss+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                    totp3=ratesgd*totp3;                            
                                }
                                if(gen.gettable(anak1.get(sss+1)).trim().indexOf("USD")>0  && gen.gettable(anak1.get(sss+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                    totp3=rateusd*totp3;
                                }
                            }
                           // if(p3_acct.startsWith("122")){
                           //     totp3=totp3*-1;
                           // }
                            data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p3_acct+"("+gen.gettable(anak1.get(sss+1)).trim()+")");                    
                            data.addElement(totp3+"");
                            ex.addElement("                             "+p3_acct+"("+gen.gettable(anak1.get(sss+1)).trim()+")");                    
                            ex.addElement(totp3+"");
                        }
                        for(int sst=0;sst<anak2.size();sst+=3){
                            String p4_acct=gen.gettable(anak2.get(sst));
                            double totp4=gen.getformatdouble(anak2.get(sst+2));                        
                            java.util.Vector anak3=sgen.getDataQuery(conn,"REPBS2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p4_acct});
                            if(anak3.size()>0 || totp4!=0){                                
                              //  if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                    if(gen.gettable(anak2.get(sst+1)).trim().indexOf("SGD")>0 && gen.gettable(anak2.get(sst+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                        totp4=ratesgd*totp4;                            
                                    }
                                    if(gen.gettable(anak2.get(sst+1)).trim().indexOf("USD")>0 && gen.gettable(anak2.get(sst+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                        totp4=rateusd*totp4;
                                    }
                               // }
                               // if(p4_acct.startsWith("122")){
                                   // totp4=totp4*-1;
                              //  }
                                data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p4_acct+"("+gen.gettable(anak2.get(sst+1)).trim()+")");                    
                                data.addElement(totp4+"");
                                ex.addElement("                                             "+p4_acct+"("+gen.gettable(anak2.get(sst+1)).trim()+")");                    
                                ex.addElement(totp4+"");
                            }
                            for(int stt=0;stt<anak3.size();stt+=3){
                                String p5_acct=gen.gettable(anak3.get(stt));
                                if(gen.getformatdouble(anak3.get(stt+2))!=0){
                                  double totp5=gen.getformatdouble(anak3.get(stt+2));
                                 // if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                      if(gen.gettable(anak3.get(stt+1)).trim().indexOf("SGD")>0&& gen.gettable(anak3.get(stt+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                          totp5=ratesgd*totp5;                            
                                      }
                                      if(gen.gettable(anak3.get(stt+1)).trim().indexOf("USD")>0&& gen.gettable(anak3.get(stt+1)).trim().toUpperCase().indexOf("EXCHANGE")<=0){
                                          totp5=rateusd*totp5;
                                      }
                                //  }
                                  //if(p4_acct.startsWith("122")){
                                     // totp4=totp4*-1;
                                  //}
                                  data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p5_acct+"("+gen.gettable(anak3.get(stt+1)).trim()+")");                    
                                  data.addElement(totp5+"");
                                  ex.addElement("                                                               "+p5_acct+"("+gen.gettable(anak3.get(stt+1)).trim()+")");                    
                                  ex.addElement(totp5+"");
                                  totp4+=totp5;
                                }
                            }
                            if(anak3.size()>0){
                                data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>TOTAL "+gen.gettable(anak2.get(sst+1)).trim()+"</b>");                
                                data.addElement(totp4+"");                                
                                ex.addElement("                                             TOTAL "+gen.gettable(anak2.get(sst+1)).trim()+"");                
                                ex.addElement(totp4+"");                                
                            }
                            totp3+=totp4;
                        }
                        if(anak2.size()>0){
                            data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>TOTAL "+gen.gettable(anak1.get(sss+1)).trim()+"</b>");                
                            data.addElement(totp3+"");                            
                            ex.addElement("                             TOTAL "+gen.gettable(anak1.get(sss+1)).trim()+"");                
                            ex.addElement(totp3+"");                            
                        }
                        totp2+=totp3;
                    }
                    if(anak1.size()>0){
                        data.addElement("<b>&nbsp;&nbsp;&nbsp;&nbsp;TOTAL "+gen.gettable(anak.get(ss+1)).trim()+"</b>");                
                        data.addElement(totp2+"");                        
                        ex.addElement("             TOTAL "+gen.gettable(anak.get(ss+1)).trim()+"");                
                        ex.addElement(totp2+"");                        
                    }
                    totp+=totp2;
                }
                if(p_acct.equalsIgnoreCase("10000")) tot1=totp;
                if(p_acct.equalsIgnoreCase("20000")) tot2=totp;
                data.addElement("<b>TOTAL "+gen.gettable(parent.get(s+1)).trim()+"</b>");                
                data.addElement(totp+"");
                ex.addElement("TOTAL "+gen.gettable(parent.get(s+1)).trim()+"");                
                ex.addElement(totp+"");
            }     
            
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"ACCOUNT,AMOUNT,");
                  ses.setAttribute("DATAXLS",ex);
                  ses.setAttribute("JUDULXLS",judulx);
                  bd.doAll(request);
            }
        }else if(tpx.equalsIgnoreCase("PL")){
            title="Profit & Loss Statement";        
            String trx=sgen.getLastDayofMonth(gen.getInt(S1),gen.getInt(S2))+"-"+mth+"-"+S2;
            java.util.Vector vkrate=sgen.getDataQuery(conn,"LISTRATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx});
            double rateusd=0;
            double ratesgd=0;
            for(int ms=0;ms<vkrate.size();ms+=2){
                if(gen.gettable(vkrate.get(ms)).trim().equalsIgnoreCase("SGD")){
                    ratesgd=gen.getformatdouble(vkrate.get(ms+1));
                }
                if(gen.gettable(vkrate.get(ms)).trim().equalsIgnoreCase("USD")){
                    rateusd=gen.getformatdouble(vkrate.get(ms+1));
                }
            }
            java.util.Vector ex=new java.util.Vector();
            double tot1=0,tot2=0,tot3=0,tot4=0,tot5=0;
            java.util.Vector parent=sgen.getDataQuery(conn,"REPPL1",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode"))});
            for(int s=0;s<parent.size();s+=3){
                String p_acct=gen.gettable(parent.get(s));
                if(p_acct.equalsIgnoreCase("60000")){
                    data.addElement("<b>GROSS PROFIT >>></b>");
                    double a=tot1-tot2;                
                    data.addElement(a+"");
                }
                if(p_acct.equalsIgnoreCase("80000")){
                    data.addElement("<b>OPERATING PROFIT >>></b>");
                    double a=tot1-tot2-tot3;                
                    data.addElement(a+"");
                }
                data.addElement(p_acct+"("+gen.gettable(parent.get(s+1)).trim()+")");                
                data.addElement(gen.gettable(parent.get(s+2)));
                
                ex.addElement(p_acct+"("+gen.gettable(parent.get(s+1)).trim()+")");                
                ex.addElement(gen.gettable(parent.get(s+2)));
                double totp=gen.getformatdouble(parent.get(s+2));
                if(p_acct.startsWith("4")||p_acct.startsWith("8")){
                    totp=totp*-1;
                }
                java.util.Vector anak=sgen.getDataQuery(conn,"REPPL2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p_acct});                
                for(int ss=0;ss<anak.size();ss+=3){
                    String p2_acct=gen.gettable(anak.get(ss));
                    double totp2=gen.getformatdouble(anak.get(ss+2));                        
                    if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                        if(gen.gettable(anak.get(ss+1)).trim().indexOf("SGD")>0){
                            totp2=ratesgd*totp2;                            
                        }
                        if(gen.gettable(anak.get(ss+1)).trim().indexOf("USD")>0){
                            totp2=rateusd*totp2;
                        }
                    }
                    if(p2_acct.startsWith("4")||p2_acct.startsWith("8")){
                        totp2=totp2*-1;
                    }
                    java.util.Vector anak1=sgen.getDataQuery(conn,"REPPL2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p2_acct});
                    if(totp2!=0 || anak1.size()>0){
                        data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;"+p2_acct+"("+gen.gettable(anak.get(ss+1)).trim()+")");                    
                        data.addElement(totp2+"");
                        ex.addElement("             "+p2_acct+"("+gen.gettable(anak.get(ss+1)).trim()+")");                    
                        ex.addElement(totp2+"");
                    }
                    for(int sss=0;sss<anak1.size();sss+=3){
                        String p3_acct=gen.gettable(anak1.get(sss));
                        double totp3=gen.getformatdouble(anak1.get(sss+2));                        
                        java.util.Vector anak2=sgen.getDataQuery(conn,"REPPL2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p3_acct});
                        if(anak2.size()>0 || totp3!=0){
                            
                            if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                if(gen.gettable(anak1.get(sss+1)).trim().indexOf("SGD")>0){
                                    totp3=ratesgd*totp3;                            
                                }
                                if(gen.gettable(anak1.get(sss+1)).trim().indexOf("USD")>0){
                                    totp3=rateusd*totp3;
                                }
                            }
                              if(p3_acct.startsWith("4")||p3_acct.startsWith("8")){
                                  totp3=totp3*-1;
                              }
                            data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p3_acct+"("+gen.gettable(anak1.get(sss+1)).trim()+")");                    
                            data.addElement(totp3+"");
                            ex.addElement("                             "+p3_acct+"("+gen.gettable(anak1.get(sss+1)).trim()+")");                    
                            ex.addElement(totp3+"");
                        }
                        for(int sst=0;sst<anak2.size();sst+=3){
                            String p4_acct=gen.gettable(anak2.get(sst));
                            double totp4=gen.getformatdouble(anak2.get(sst+2));                        
                            java.util.Vector anak3=sgen.getDataQuery(conn,"REPPL2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1,gen.gettable(ses.getAttribute("TxtErcode")),p4_acct});
                            if(anak3.size()>0 || totp4!=0){                                
                                if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                    if(gen.gettable(anak2.get(sst+1)).trim().indexOf("SGD")>0){
                                        totp4=ratesgd*totp4;                            
                                    }
                                    if(gen.gettable(anak2.get(sst+1)).trim().indexOf("USD")>0){
                                        totp4=rateusd*totp4;
                                    }
                                }
                                if(p4_acct.startsWith("4")){
                                    totp4=totp4*-1;
                                }
                                data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p4_acct+"("+gen.gettable(anak2.get(sst+1)).trim()+")");                    
                                data.addElement(totp4+"");
                                ex.addElement("                                             "+p4_acct+"("+gen.gettable(anak2.get(sst+1)).trim()+")");                    
                                ex.addElement(totp4+"");
                            }
                            for(int stt=0;stt<anak3.size();stt+=3){
                                String p5_acct=gen.gettable(anak3.get(stt));
                                if(gen.getformatdouble(anak3.get(stt+2))!=0){
                                  double totp5=gen.getformatdouble(anak3.get(stt+2));
                                  if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
                                      if(gen.gettable(anak3.get(stt+1)).trim().indexOf("SGD")>0){
                                          totp5=ratesgd*totp5;                            
                                      }
                                      if(gen.gettable(anak3.get(stt+1)).trim().indexOf("USD")>0){
                                          totp5=rateusd*totp5;
                                      }
                                  }
                                  if(p5_acct.startsWith("4")||p5_acct.startsWith("8")){
                                      totp5=totp5*-1;
                                  }
                                  data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+p5_acct+"("+gen.gettable(anak3.get(stt+1)).trim()+")");                    
                                  data.addElement(totp5+"");
                                  ex.addElement("                                                               "+p5_acct+"("+gen.gettable(anak3.get(stt+1)).trim()+")");                    
                                  ex.addElement(totp5+"");
                                  totp4+=totp5;
                                }
                            }
                            if(anak3.size()>0){
                                data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>TOTAL "+gen.gettable(anak2.get(sst+1)).trim()+"</b>");                
                                data.addElement(totp4+"");                                
                                ex.addElement("                                                               TOTAL "+gen.gettable(anak2.get(sst+1)).trim()+"");                
                                ex.addElement(totp4+"");                                
                            }
                            totp3+=totp4;
                        }
                        if(anak2.size()>0){
                            data.addElement("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>TOTAL "+gen.gettable(anak1.get(sss+1)).trim()+"</b>");                
                            data.addElement(totp3+"");                            
                            ex.addElement("                             TOTAL "+gen.gettable(anak1.get(sss+1)).trim()+"");                
                            ex.addElement(totp3+"");                            
                        }
                        totp2+=totp3;
                    }
                    if(anak1.size()>0){
                        data.addElement("<b>&nbsp;&nbsp;&nbsp;&nbsp;TOTAL "+gen.gettable(anak.get(ss+1)).trim()+"</b>");                
                        data.addElement(totp2+"");                        
                        ex.addElement("              TOTAL "+gen.gettable(anak.get(ss+1)).trim()+"");                
                        ex.addElement(totp2+"");                        
                    }
                    totp+=totp2;
                }
                if(p_acct.equalsIgnoreCase("40000")) tot1=totp;
                if(p_acct.equalsIgnoreCase("50000")) tot2=totp;
                if(p_acct.equalsIgnoreCase("60000")) tot3=totp;
                if(p_acct.equalsIgnoreCase("80000")) tot4=totp;
                if(p_acct.equalsIgnoreCase("90000")) tot5=totp;
                data.addElement("<b>TOTAL "+gen.gettable(parent.get(s+1)).trim()+"</b>");                
                data.addElement(totp+"");
                ex.addElement("TOTAL "+gen.gettable(parent.get(s+1)).trim()+"");                
                ex.addElement(totp+"");
            }     
            double n=tot1-tot2-tot3+tot4-tot5;                
            data.addElement("<b>NET PROFIT (LOSS)</b>");
            data.addElement(n+"");
            ex.addElement("NET PROFIT (LOSS)");
            ex.addElement(n+"");
            
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();                  
                  java.util.Vector judulx=gen.getElement(',',"ACCOUNT,AMOUNT,");
                  ses.setAttribute("DATAXLS",ex);
                  ses.setAttribute("JUDULXLS",judulx);
                  bd.doAll(request);
            }        
        }else if(tpx.equalsIgnoreCase("GL")){
            title="General Ledger";        
            data=sgen.getDataQuery(conn,tpx,new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S2,S1});
            datadetail=sgen.getDataQuery(conn,"GLDETAIL",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(ses.getAttribute("TxtErcode")),S2,S1});            
            
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();//[GLId],TRXDATE,CURR,REMARKS,TRXTYPE,REFNO,[AcctNo],b.[Description],Debit,[Credit],[Rate],[IdrDebet],[IdrCredit],[JobNo],[Note1],[Note2] 
                  java.util.Vector judulx=gen.getElement(',',"GLID,DATE,CURRENCY,REMARK,TRXTYPE,REF. NO.,ACCT,ACCT DESCRIPTION,Debit,Credit,RATE,DEBIT-IDR,CREDIT-IDR,JOBNO,NOTE 1,NOTE 2,");
                  java.util.Vector ex=sgen.getDataQuery(conn,"GLDETAILEXCEL",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(ses.getAttribute("TxtErcode")),S2,S1});
                  ses.setAttribute("DATAXLS",ex);
                  ses.setAttribute("JUDULXLS",judulx);
                  bd.doAll(request);
            }        
        }else if(tpx.equalsIgnoreCase("AC")){
            title="Account History";        
            data=sgen.getDataQuery(conn,tpx,new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S7")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5"))});
            String m=gen.gettable(request.getParameter("S4"));
            String y=gen.gettable(request.getParameter("S6"));
            String prevy=y,prevm=(gen.getInt(m)-1)+"";
             
            if(prevm.equalsIgnoreCase("0")){
              prevy=(gen.getInt(prevy)-1)+"";
              prevm="12";
            }
            
            datadetail=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),prevy,prevm,gen.gettable(request.getParameter("S7"))});
            
            if(datadetail.size()>0){
                stot1=gen.getformatdouble(datadetail.get(0));
            }        
            stot2=stot1;    
            for(int s=0;s<data.size();s+=9){
                stot2+=gen.getformatdouble(data.get(5+s))-gen.getformatdouble(data.get(6+s));
            }
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();//[GLId],TRXDATE,CURR,REMARKS,TRXTYPE,REFNO,[AcctNo],b.[Description],Debet,[Credit],[Rate],[IdrDebet],[IdrCredit],[JobNo],[Note1],[Note2] 
                  java.util.Vector judulx=gen.getElement(',',"GL ID,DATE,TYPE,REF.NO.,CURR,Debit,Credit,JOBNO,MEMO,");
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  bd.doAll(request);
            }        
        }
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>

	<body class="no-skin"  <%if(gen.gettable(request.getParameter("tpx")).startsWith("Download")){%> onload="pop()"<%}%>>
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">

						<div class="page-header">
							<h1>
								<%=title%>&nbsp;&nbsp;&nbsp;<a href="javascript:down()"><img width=30 height=30 src=image/download.jfif ></a>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
											<form class="form-horizontal" name="BGA" method="POST" action="gllaporan.jsp" >
                                            <div class="form-group">
                                                    <label class="control-label">Month:<select name="S1" onchange="refresh();"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(S1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
            										<label class="control-label">&nbsp;&nbsp;Year:<select  name="S2" onchange="refresh();"><%for(int m=0;m<combo2.size();m++){%><option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(S2.trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option><%}%></select>  </label>
                                                    <label class="control-label">&nbsp;&nbsp;Report:<select name="S3" onchange="refresh();">                                                       	
                                                       	<option value="BS" <%if(Gen.gettable(request.getParameter("S3")).trim().equalsIgnoreCase("BS")) out.print("selected");%>>Balance Sheet</option>
                                                       	<option value="PL" <%if(Gen.gettable(request.getParameter("S3")).trim().equalsIgnoreCase("PL")) out.print("selected");%>>Profit & Loss Statement</option>
                                                        <option value="GL" <%if(Gen.gettable(request.getParameter("S3")).trim().equalsIgnoreCase("GL")) out.print("selected");%>>General Ledger</option>
                                                        <option value="AC" <%if(Gen.gettable(request.getParameter("S3")).trim().equalsIgnoreCase("AC")) out.print("selected");%>>Account History</option>
                                                        </select>  
                                                </label>  
                                            </div>
                                                <input type="hidden" name="tp" value="<%=gen.gettable(request.getParameter("tp"))%>">
                                                <input type="hidden" name="tpx" value="">
                                                <input type="hidden" name="tb" value="<%=title%>">
                                                <input type="hidden" name="act" value="">
                                            </form>
                                    </div>
                                 </div>
                               </div>
                             </div>
                          </div>
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div class="row">
									<div class="col-xs-12">

										<!-- div.table-responsive -->

										<!-- div.dataTables_borderWrap -->
										<div>
                                        <%if(tpx.equalsIgnoreCase("GL")){
                                            judul=new String[]{"GLID","DATE","CURRENCY","REMARK","TRXTYPE","REF. NO."};                                                                                     
                                        %>
                										<table id="simple-table" class="table  table-bordered table-hover">
                											<thead>
                												<tr>													
                                                                    <td class="detail-col"><b>Details</td>
                                                                        <%for(int s=0;s<judul.length;s++){%>         
                														<td align=center><b><%=judul[s]%>&nbsp;</td>
                                                                        <%}%>
                    											</tr>
                											</thead>
                
                											<tbody>                                                                   
                                                               <%  int hic=1;
                                                            for(int s=0;s<data.size();s+=judul.length){%>         
                												<tr>
                  													<td class="center">
                  														<div class="action-buttons">
                  															<a href="#" class="green bigger-140 show-details-btn" title="Show Details">
                  																<i class="ace-icon fa fa-angle-double-down"></i>
                  																<span class="sr-only">Details</span>
                  															</a>
                  														</div>
                  													</td>
                                                                   <%for(int ss=0;ss<judul.length;ss++){%>
                                                                        <td nowrap><%=gen.gettable(data.get(s+ss)).trim()%></td>
                                                                    <%}%>
                												</tr>
                  												<tr class="detail-row">
                  													<td colspan="7">
                        											<table id="c-table" class="table table-striped table-bordered table-hover">
                          												<thead>
                          													<tr>
                                                                                  <td  align=center><b>ACCOUNT</td>
                                                                                  <td align=center><b>DESCRIPTION</td>
                                                                                  <td align=center><b>DEBIT</td>
                                                                                  <td align=center><b>CREDIT</td>
                                                                                  <td align=center><b>RATE</td>
                                                                                  <td align=center><b>DEBIT (IDR)</td>
                                                                                  <td align=center><b>CREDIT (IDR)</td>
                                                                                  <td align=center><b>JOBNO</td>
                                                                            </tr>
                                                                        </thead>
                        												<tbody>
                                                                          <%for(int ii=0;ii<datadetail.size();ii+=11){
                                                                            if(Gen.gettable(data.get(s)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii)).trim())){%>
                                                      						<tr>
                                                                                <td nowrap><%=Gen.gettable(datadetail.get(ii+1)).trim()%></td>
                                                                                <td nowrap><%=Gen.gettable(datadetail.get(ii+2)).trim()%></td>
                                                                                <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+3),2)%></td>
                                                                                <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+4),2)%></td>
                                                                                <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+5),0)%></td>
                                                                                <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+6),0)%></td>
                                                                                <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+7),0)%></td>
                                                                                <td nowrap><%=Gen.gettable(datadetail.get(ii+8)).trim()%></td>
                                                          						</tr>
                                                                            <%}
                                                                            }%>    
                                                                        </tbody>
                                                                    </table>    
            													 </td>
            												  </tr>                                                                                                                            
                                                        <%}//for(int s=0;s<data.size();s+=judul.length){%>
            											</tbody>
            										</table>
                                        <%}else if(tpx.equalsIgnoreCase("AC")){%>
                          						<form class="form-horizontal" name="BG" method="POST" action="gllaporan.jsp?tp=<%=tp%>" >                                                    
                                                    <label class="control-label">Start Month:<select name="S4" onchange="ref();"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(gen.gettable(request.getParameter("S4")).trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
                                                    <label class="control-label">&nbsp;&nbsp;To Month:<select name="S5" onchange="ref();"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(gen.gettable(request.getParameter("S5")).trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
                                                    <label class="control-label">&nbsp;&nbsp;Year:<select  name="S6" onchange="ref();"><%for(int m=0;m<combo2.size();m++){%><option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(gen.gettable(request.getParameter("S6")).trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option><%}%></select> </label>
                                                    <label class="control-label">&nbsp;&nbsp;Account
                                      		              <input type="text" name="S7"  size="5" maxlength=5 value="<%=gen.gettable(request.getParameter("S7"))%>" onchange="ref()">
                                      		              <input type="text" name="S8" size="25" value="<%=gen.gettable(request.getParameter("S8")).trim()%>" >
                     				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('ACCOUNT','S7','S8','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                    &nbsp;</label>
                                                    <label class="control-label">&nbsp;&nbsp;Start Balance:<b><%=gen.getNumberFormat(stot1+"",2)%></b>&nbsp;</label>
                                                    <label class="control-label">&nbsp;&nbsp;Ending Balance:<b><%=gen.getNumberFormat(stot2+"",2)%></b>&nbsp;</label>
                                            </div>
                                        </div>
										<div class="row">
									           <div class="col-xs-12">
                                                    	<table id="simple-table" class="table  table-bordered table-hover">
                											<thead>
                												<tr>			
                                                                    <td  align=center><b>GL ID</td>
                                                                    <td align=center><b>DATE</td>
                                                                    <td align=center><b>TYPE</td>
                                                                    <td align=center><b>REF.NO.</td>
                                                                    <td align=center><b>CURR</td>
                                                                    <td align=center><b>DEBIT</td>
                                                                    <td align=center><b>CREDIT</td>
                                                                    <td align=center><b>JOBNO</td>
                                                                    <td align=center><b>MEMO</td>
                    											</tr>
                											</thead>
                
                											<tbody>                                                                   
                                                               <%  int hic=1;
                                                            double td=0,tc=0;
                                                            for(int s=0;s<data.size();s+=9){
                                                                td+=gen.getformatdouble(data.get(s+5));
                                                                tc+=gen.getformatdouble(data.get(s+6));
                                                            %>         
                												<tr>
                                                                   <%for(int ss=0;ss<9;ss++){%>
                                                                        <%if(ss==5||ss==6){%>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(data.get(s+ss),2)%></td>
                                                                        <%}else{%>
                                                                        <td nowrap><%=gen.gettable(data.get(s+ss)).trim()%></td>
                                                                        <%}%>
                                                                    <%}%>
                												</tr>
                                                            <%}//%>
                												<tr>
                                                                    <td nowrap colspan=5 align=right><b>TOTAL:</b></td>
                                                                    <td nowrap align=right><b><%=gen.getNumberFormat(td+"",2)%></b></td>
                                                                    <td nowrap align=right><b><%=gen.getNumberFormat(tc+"",2)%></b></td>
                                                                    <td nowrap ></td>
                                                                    <td nowrap ></td>
                												</tr>
            											</tbody>
            										</table>
                                                    </div>
                                                    <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>">
                                                    <input type="hidden" name="S2" value="<%=gen.gettable(request.getParameter("S2"))%>">
                                                    <input type="hidden" name="S3" value="<%=gen.gettable(request.getParameter("S3"))%>">
                                                      <input type="hidden" name="act" value="">
                                              </form>
                                        <%}else{%>
											<table id="dynamic-table" class="table table-striped table-bordered table-hover">
												<thead>
													<tr>
                                                        <%for(int s=0;s<judul.length;s++){%>         
														<th><%=judul[s]%></th>
                                                        <%}%>
													</tr>
												</thead>

												<tbody>
                                                   <%for(int s=0;s<data.size();s+=judul.length){%>         
													<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                       %>         														
                                                            <%if(judul[ss].endsWith("AMOUNT")||judul[ss].startsWith("PROFIT")||judul[ss].startsWith("TOTAL")||judul[ss].startsWith("DEBIT")||judul[ss].startsWith("CREDIT")){%>
                                                            <td align=right nowrap><%if(gen.gettable(data.get(s+ss-1)).trim().endsWith("</b>")) out.print("<b>");%><%=gen.getNumberFormat(data.get(s+ss),0)%><%if(gen.gettable(data.get(s+ss-1)).trim().endsWith("</b>")) out.print("</b>");%></td>
                                                            <%}else{%>
                                                                <td nowrap><%=gen.gettable(data.get(s+ss)).trim()%></td>
                                                            <%}%>
                                                        <%}%>
													</tr>
                                                    <%}%>
												</tbody>
											</table>
                                            <%}%>
										</div>
									</div>
								</div>

								<div id="modal-table" class="modal fade" tabindex="-1">
									<div class="modal-dialog">
										<div class="modal-content">

											<div class="modal-footer no-margin-top">
												<button class="btn btn-sm btn-danger pull-left" data-dismiss="modal">
													<i class="ace-icon fa fa-times"></i>
													Close
												</button>

												<ul class="pagination pull-right no-margin">
													<li class="prev disabled">
														<a href="#">
															<i class="ace-icon fa fa-angle-double-left"></i>
														</a>
													</li>

													<li class="active">
														<a href="#">1</a>
													</li>

													<li>
														<a href="#">2</a>
													</li>

													<li>
														<a href="#">3</a>
													</li>

													<li class="next">
														<a href="#">
															<i class="ace-icon fa fa-angle-double-right"></i>
														</a>
													</li>
												</ul>
											</div>
										</div><!-- /.modal-content -->
									</div><!-- /.modal-dialog -->
								</div>

								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->
        <jsp:include page="footer.jsp" flush ="true"/>

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="assets/js/jquery-2.1.4.min.js"></script>

		<!-- <![endif]-->

		<!--[if IE]>
<script src="assets/js/jquery-1.11.3.min.js"></script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
		<script src="assets/js/buttons.flash.min.js"></script>
		<script src="assets/js/buttons.html5.min.js"></script>
		<script src="assets/js/buttons.print.min.js"></script>
		<script src="assets/js/buttons.colVis.min.js"></script>
		<script src="assets/js/dataTables.select.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
    <%if(tpx.equalsIgnoreCase("GL")){%>
			jQuery(function($) {
				var active_class = 'active';
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]' , function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
			
				
			
				/********************************/
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					//var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				
				
				
				
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				/***************/
				
				
				
				
				
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
				  {
					horizontal: true,
					styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
					size: 2000,
					mouseWheelLock: true
				  }
				).css('padding-top', '12px');
				*/
			
			
			})
    <%}else{%>
			jQuery(function($) {                
				//initiate dataTables plugin
				var myTable = 
				$('#dynamic-table')
				//.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
				.DataTable( {
					bAutoWidth: false,
					"aoColumns": [
					  //{ "bSortable": false },
					  <%
                      for(int m=0;m<judul.length;m++){out.print("null,");}
                      if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("PASIF")) out.print("null,");
                      %>
					  //{ "bSortable": false }
					],
					"aaSorting": [],
					
					
					//"bProcessing": true,
			        //"bServerSide": true,
			        //"sAjaxSource": "http://127.0.0.1/table.php"	,
			
					//,
					//"sScrollY": "200px",
					//"bPaginate": false,
			
					//"sScrollX": "100%",
					//"sScrollXInner": "120%",
					//"bScrollCollapse": true,
					//Note: if you are applying horizontal scrolling (sScrollX) on a ".table-bordered"
					//you may want to wrap the table inside a "div.dataTables_borderWrap" element
			
					"iDisplayLength": 100,
			
			
					select: {
						style: 'multi'
					}
			    } );
			
				
				
				$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
				
				new $.fn.dataTable.Buttons( myTable, {
					buttons: [
					  {
						"extend": "colvis",
						"text": "<i class='fa fa-search bigger-110 blue'></i> <span class='hidden'>Show/hide columns</span>",
						"className": "btn btn-white btn-primary btn-bold",
						columns: ':not(:first):not(:last)'
					  },
					  {
						"extend": "copy",
						"text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
						"className": "btn btn-white btn-primary btn-bold"
					  },
					  {
						"extend": "csv",
						"text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
						"className": "btn btn-white btn-primary btn-bold"
					  },
					  {
						"extend": "excel",
						"text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
						"className": "btn btn-white btn-primary btn-bold"
					  },
					  {
						"extend": "pdf",
						"text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
						"className": "btn btn-white btn-primary btn-bold"
					  },
					  {
						"extend": "print",
						"text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
						"className": "btn btn-white btn-primary btn-bold",
						autoPrint: false,
						message: 'This print was produced using the Print button for DataTables'
					  }		  
					]
				} );
				myTable.buttons().container().appendTo( $('.tableTools-container') );
				
				//style the message box
				var defaultCopyAction = myTable.button(1).action();
				myTable.button(1).action(function (e, dt, button, config) {
					defaultCopyAction(e, dt, button, config);
					$('.dt-button-info').addClass('gritter-item-wrapper gritter-info gritter-center white');
				});
				
				
				var defaultColvisAction = myTable.button(0).action();
				myTable.button(0).action(function (e, dt, button, config) {
					
					defaultColvisAction(e, dt, button, config);
					
					
					if($('.dt-button-collection > .dropdown-menu').length == 0) {
						$('.dt-button-collection')
						.wrapInner('<ul class="dropdown-menu dropdown-light dropdown-caret dropdown-caret" />')
						.find('a').attr('href', '#').wrap("<li />")
					}
					$('.dt-button-collection').appendTo('.tableTools-container .dt-buttons')
				});
			
				////
			
				setTimeout(function() {
					$($('.tableTools-container')).find('a.dt-button').each(function() {
						var div = $(this).find(' > div').first();
						if(div.length == 1) div.tooltip({container: 'body', title: div.parent().text()});
						else $(this).tooltip({container: 'body', title: $(this).text()});
					});
				}, 500);
				
				
				
				
				
				myTable.on( 'select', function ( e, dt, type, index ) {
					if ( type === 'row' ) {
						$( myTable.row( index ).node() ).find('input:checkbox').prop('checked', true);
					}
				} );
				myTable.on( 'deselect', function ( e, dt, type, index ) {
					if ( type === 'row' ) {
						$( myTable.row( index ).node() ).find('input:checkbox').prop('checked', false);
					}
				} );
			
			
			
			
				/////////////////////////////////
				//table checkboxes
				$('th input[type=checkbox], td input[type=checkbox]').prop('checked', false);
				
				//select/deselect all rows according to table header checkbox
				$('#dynamic-table > thead > tr > th input[type=checkbox], #dynamic-table_wrapper input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$('#dynamic-table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) myTable.row(row).select();
						else  myTable.row(row).deselect();
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#dynamic-table').on('click', 'td input[type=checkbox]' , function(){
					var row = $(this).closest('tr').get(0);
					if(this.checked) myTable.row(row).deselect();
					else myTable.row(row).select();
				});
			
			
			
				$(document).on('click', '#dynamic-table .dropdown-toggle', function(e) {
					e.stopImmediatePropagation();
					e.stopPropagation();
					e.preventDefault();
				});
				
				
				
				//And for the first simple table, which doesn't have TableTools or dataTables
				//select/deselect all rows according to table header checkbox
				var active_class = 'active';
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]' , function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
			
			
				
			
				/********************************/
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					//var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				
				
				
				
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				/***************/
				
				
				
				
				
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
				  {
					horizontal: true,
					styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
					size: 2000,
					mouseWheelLock: true
				  }
				).css('padding-top', '12px');
				*/
			
			
			})
    <%}//if(tpx.equalsIgnoreCase("GL")){%>            
            function onact(Parm1,Parm2,Parm3){
            	window.open("viewdokumen.jsp?tp=<%=gen.gettable(request.getParameter("tp"))%>&Y11="+Parm1+"&Y12="+Parm2+"&Y13="+Parm3,"Cetak Dokumen", "height=400,width=850,toolbar=no,scrollbars=YES,menubar=no");
            }
            
            function refresh(){
                BGA.submit();
            }
            function ref(){
                BG.submit();
            }
            function down(){
                document.BGA.tpx.value="Download";
                BGA.submit();
            }
	function jump(P1,P2,P3,P4,P5,P6){
		url="movementc.jsp?tp="+P1+"&S1="+P2+"&S2="+P3+"&S3="+P4+"&S4="+P5+"&S5="+P6;
		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
	}
            
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            
		</script>
	</body>
</html>
