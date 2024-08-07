<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="3 styles with inline editable feature" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->
		<link rel="stylesheet" href="assets/css/jquery-ui.custom.min.css" />
		<link rel="stylesheet" href="assets/css/jquery.gritter.min.css" />
		<link rel="stylesheet" href="assets/css/select2.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-datepicker3.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-editable.min.css" />

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
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
      //      System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        String msg="";
        String y1=Gen.gettable(request.getParameter("S1"));
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
            conn.setAutoCommit(false);
            String t2=Gen.gettable(request.getParameter("T2"));//trxdate
            java.util.Vector vkst=gen.getElement('-',t2+"-");
            String yr=gen.gettable(vkst.get(2));
            String mth=gen.gettable(vkst.get(1));
            if(mth.length()==1) mth="0"+mth;
            if(Gen.gettable(request.getParameter("add")).equalsIgnoreCase("true")){//Umum
                String jb=Gen.gettable(request.getParameter("T3")).trim().toUpperCase()+yr+mth+"%";
                if(gen.gettable(ses.getAttribute("TxtErcode")).trim().equalsIgnoreCase("M")) jb="%";
                java.util.Vector exist=sgen.getDataQuery(conn,"JOBMAXSEQNEW",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jb});
                if(gen.gettable(ses.getAttribute("TxtErcode")).trim().equalsIgnoreCase("M")){
                  if(Gen.gettable(request.getParameter("T1")).length()==0){
                    String seq="";
                    if(exist.size()>0){                         
                        String nextno=gen.gettable(exist.get(0)).trim();
                        int g=gen.getInt(nextno)+1;
                        seq=g+"";
                        while(seq.length()<8){
                            seq="0"+seq;
                        }
                    }else{
                        seq="00000001";
                    }
                    y1=seq;
                  }else{
                    y1=Gen.gettable(request.getParameter("T1"));
                  }
                }else{
                  String pref=Gen.gettable(request.getParameter("T3")).trim().toUpperCase()+yr+mth;
                  String seq="";
                  if(exist.size()>0){
                      if(gen.gettable(exist.get(0)).trim().length()>4){   
                        String nextno=gen.gettable(exist.get(0)).substring(pref.length());
                        int g=gen.getInt(nextno)+1;
                        seq=g+"";
                        while(seq.length()<3){
                            seq="0"+seq;
                        }
                      }else{
                          seq="001";
                      }
                  }else{
                      seq="001";
                  }
                  y1=pref+seq;//Gen.gettable(request.getParameter("T1"));//jobno
                }
                if(msg.length()==0) msg=sgen.update(conn,"JOBNEWADD",new String[]{gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),
                gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T13")),""+gen.getformatdouble(request.getParameter("T8")),
                ""+gen.getformatdouble(request.getParameter("T9")),""+gen.getformatdouble(request.getParameter("T10")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T14")),
                gen.gettable(request.getParameter("PT8")),gen.gettable(request.getParameter("PT9")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),gen.gettable(ses.getAttribute("TxtErcode")),y1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBNEWADD",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+y1+"|"});
            }else{//update
            //[SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[Customer],[Note],[TotSalesAmt],[TotCostAmt],[TotProfit] ,[contno] ,[rate],[totpctsales] ,[totpctcost],[ErCode] ,[JobNo]
                if(msg.length()==0) msg=sgen.update(conn,"JOBNEWUPDATE",new String[]{gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),
                gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T13")),""+gen.getformatdouble(request.getParameter("T8")),
                ""+gen.getformatdouble(request.getParameter("T9")),""+gen.getformatdouble(request.getParameter("T10")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T14")),
                gen.gettable(request.getParameter("PT8")),gen.gettable(request.getParameter("PT9")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("T1"))});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBNEWUPDATE",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("T1"))+"|"});
            }
            if(msg.length()==0){
            //[ErCode],[JobNo],[Seq],[BillTo],[AcctNo],[DK],[Curr],[Amt],[CheckFlag],[IDRAmt] ,[Perc],[FinalAmt],[MYOB],[percflag],[rate]
                java.util.Vector oldcost=(java.util.Vector)ses.getAttribute("OLDCOST");
                java.util.Vector oldsales=(java.util.Vector)ses.getAttribute("OLDSALES");
                if(msg.length()==0) msg=sgen.update(conn,"JOBCOSTDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1});
                if(msg.length()==0) msg=sgen.update(conn,"JOBSALESDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1});
                java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                int curmth=gen.getInt(userdef.get(0)),curyr=gen.getInt(userdef.get(1));
                int hx=gen.getInt(request.getParameter("CS"));
                String tod=gen.getToday("dd-MM-yyyy");
                for(int m=1;m<=hx;m++){
                    if(gen.gettable(request.getParameter("A"+m)).length()>0 || gen.gettable(request.getParameter("B"+m)).length()>0){
                        String rate=gen.gettable(request.getParameter("J"+m));
                        //if(gen.getformatdouble(rate)==0)rate="1";
                        String curr=gen.gettable(request.getParameter("C"+m)).trim();
                        String flag="0",cek="0";
                        if(gen.gettable(request.getParameter("E"+m)).equalsIgnoreCase("ON")) cek="1";
                        if(msg.length()==0 && y1.length()>0) msg=sgen.update(conn,"JOBSALESADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,m+"",gen.gettable(request.getParameter("A"+m)),
                        gen.gettable(request.getParameter("B"+m)),"D",curr,gen.gettable(request.getParameter("D"+m)),cek,gen.gettable(request.getParameter("F"+m)),
                        "2",gen.gettable(request.getParameter("H"+m)),gen.gettable(request.getParameter("I"+m)),flag,rate,gen.gettable(request.getParameter("II"+m))});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBSALESADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("A"+m))+"|"+gen.gettable(request.getParameter("B"+m))+"|"});
                    }
                }
                if(msg.length()==0){
                        //nyusupin AR
                        //[ErCode],[JobNo],[Seq],[BillTo],[AcctNo],[DK],[Curr],[Amt],[CheckFlag],[IDRAmt] ,[Perc],[FinalAmt],[MYOB],[percflag],[rate],remarks
                        for(int ms=0;ms<oldsales.size();ms+=14){//[BillTo],[AcctNo],[Curr],[Amt],[CheckFlag],[IDRAmt],[seq],[FinalAmt],[MYOB],VMST_BillTo.CodeDesc,RATE,remarks,PAIDAMT,GLID
                               // if(gen.getInt(mth)!=curmth && cek.equalsIgnoreCase("1")){//
                                 //   if(msg.length()==0) msg=sgen.update(conn,"SALESACCRUALGL",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(request.getParameter("A"+m)),gen.gettable(request.getParameter("B"+m))});
                                //}
                                if(msg.length()==0) msg=sgen.update(conn,"SALESPAYGLUPDATE",new String[]{gen.gettable(oldsales.get(ms+12)).trim(),gen.gettable(oldsales.get(ms+13)).trim(),gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(oldsales.get(ms)),gen.gettable(oldsales.get(ms+1)),gen.gettable(oldsales.get(ms+7)).trim()});
                           //     if(msg.length()==0) msg=sgen.update(conn,"SALESUPDATE",new String[]{gen.gettable(oldsales.get(ms+6)).trim(),gen.gettable(oldsales.get(ms+4)).trim(),gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(request.getParameter("A"+m)),gen.gettable(request.getParameter("B"+m)),gen.gettable(oldsales.get(ms+7)).trim()});
                        }
                }
                if(msg.length()==0) {
                  hx=gen.getInt(request.getParameter("CC"));
                  for(int m=1;m<=hx;m++){//[ErCode] ,[JobNo] ,[Seq] ,[Vendor],[AcctNo],[Invoice] ,[CurrCost],[AmtCost],[CheckFlag],[IDRAmtCost],[PercCost],[FinalCost],[MYOB],[percflag],[rate]
                      if(gen.gettable(request.getParameter("K"+m)).length()>0 || gen.gettable(request.getParameter("L"+m)).length()>0){
                          String rate=gen.gettable(request.getParameter("U"+m));
                          //if(gen.getformatdouble(rate)==0)rate="1";
                          String curr=gen.gettable(request.getParameter("N"+m)).trim();
                          String flag="0",cek="0";
                          //if(gen.gettable(request.getParameter("R"+m)).equalsIgnoreCase("ON")) flag="1";
                          if(gen.gettable(request.getParameter("P"+m)).equalsIgnoreCase("ON")) cek="1";
                          if(y1.trim().length()>0){
                            if(msg.length()==0) msg=sgen.update(conn,"JOBCOSTADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,m+"",
                            gen.gettable(request.getParameter("K"+m)),gen.gettable(request.getParameter("L"+m)),gen.gettable(request.getParameter("M"+m)),curr,gen.gettable(request.getParameter("O"+m)),
                            cek,gen.gettable(request.getParameter("Q"+m)),"2",gen.gettable(request.getParameter("W"+m)),gen.gettable(request.getParameter("V"+m)),flag,rate,gen.gettable(request.getParameter("VV"+m))});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBCOSTADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("K"+m))+"|"+gen.gettable(request.getParameter("L"+m))+"|"});
                          }
                      }
                  }
                  if(msg.length()==0){
                          //[ErCode] ,[JobNo] ,[Seq] ,[Vendor],[AcctNo],[Invoice] ,[CurrCost],[AmtCost],[CheckFlag],[IDRAmtCost],[PercCost],[FinalCost],[MYOB],[percflag],[rate],remarks
                            for(int ms=0;ms<oldcost.size();ms+=15){//
                                    //if(gen.getInt(mth)!=curmth && cek.equalsIgnoreCase("1")){//
                                      //  if(msg.length()==0) msg=sgen.update(conn,"COSTACCRUALGL",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(request.getParameter("K"+m)),gen.gettable(request.getParameter("L"+m)),gen.gettable(request.getParameter("M"+m))});
                                    //}
                                    if(msg.length()==0) msg=sgen.update(conn,"COSTPAYGLUPDATE",new String[]{gen.gettable(oldcost.get(ms+13)).trim(),gen.gettable(oldcost.get(ms+14)).trim(),gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(oldcost.get(ms)),gen.gettable(oldcost.get(ms+1)),gen.gettable(oldcost.get(ms+2)),gen.gettable(oldcost.get(ms+7)).trim()});
                                  //  if(msg.length()==0) msg=sgen.update(conn,"COSTUPDATE",new String[]{gen.gettable(oldcost.get(ms+5)).trim(),gen.gettable(ses.getAttribute("TxtErcode")),y1,gen.gettable(request.getParameter("K"+m)),gen.gettable(request.getParameter("L"+m)),gen.gettable(request.getParameter("M"+m)),gen.gettable(oldcost.get(ms+7)).trim()});
                            }
                    }
                    if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1});
                    if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD2",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1});
                    
                }
            }
            if(msg.length()>0){
                conn.rollback();
                msg="(Save Failed!!"+msg+")";
            }else{
                conn.commit();
                msg="(Saved Successfully)";
            }     
            conn.setAutoCommit(true);
        }
        
        //[JobNo],[Seq],[TrxDate],[Acct],[DebetKredit],[RefNo1],[Code],[TypeJob],[JobStatus],[USD],[SGD],[IDR] ,[Rate],[Comment],[Desc],[RefNo2],[Vendor],[BillTo],[Customer],[MYOBNO],[MYOBAMT],[MYOBSTATUS]
        String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1};
        java.util.Vector vk=sgen.getDataQuery(conn,"JOBNEWDETAIL",cond);
        String add="false";
        if(vk.size()==0){
            for(int m=0;m<21;m++)vk.addElement("");
            vk.setElementAt(gen.getToday("dd-MM-yyyy"),3);
            add="true";
        }
        java.util.Vector sales=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) sales=sgen.getDataQuery(conn,"JOBSALES",cond);
        java.util.Vector cost=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) cost=sgen.getDataQuery(conn,"JOBCOST",cond);
        java.util.Vector oldsales=sgen.getDataQuery(conn,"JOBSALESOLD",cond);
        java.util.Vector oldcost=sgen.getDataQuery(conn,"JOBCOSTOLD",cond);
        ses.setAttribute("OLDCOST",oldcost);
        ses.setAttribute("OLDSALES",oldsales);
        String vendor ="",vdesc="";
        String billto ="",bdesc="";
        if(gen.gettable(ses.getAttribute("TxtErcode")).trim().equalsIgnoreCase("M")){
          java.util.Vector vdr=sgen.getDataQuery(conn,"DEFAULTVDR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector bil=sgen.getDataQuery(conn,"DEFAULTBILL",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          if(vdr.size()>0){
              vendor=gen.gettable(vdr.get(0)).trim();
              vdesc=gen.gettable(vdr.get(1)).trim();
          }
          
          if(bil.size()>0){
              billto=gen.gettable(bil.get(0)).trim();
              bdesc=gen.gettable(bil.get(1)).trim();
          }
        }
     //   System.out.println(request.getParameter("S1")+",y1="+y1+","+request.getParameter("act")+",cost="+cost.size());
        if(request.getParameter("act")!=null){            
              vk.setElementAt(gen.gettable(request.getParameter("T1")),0);
              vk.setElementAt(gen.gettable(request.getParameter("T3")),1);
              vk.setElementAt(gen.gettable(request.getParameter("T4")),2);
              vk.setElementAt(gen.gettable(request.getParameter("T2")),3);
              vk.setElementAt(gen.gettable(request.getParameter("T6")),4);
              vk.setElementAt(gen.gettable(request.getParameter("T7")),5);
              vk.setElementAt(gen.gettable(request.getParameter("T5")),6);
              vk.setElementAt(gen.gettable(request.getParameter("T13")),7);
              vk.setElementAt(gen.gettable(request.getParameter("T8")),8);
              vk.setElementAt(gen.gettable(request.getParameter("T9")),9);
              vk.setElementAt(gen.gettable(request.getParameter("T10")),10);
              vk.setElementAt(gen.gettable(request.getParameter("T11")),11);
              vk.setElementAt(gen.gettable(request.getParameter("T12")),12);
              vk.setElementAt(gen.gettable(request.getParameter("ST5")),13);
              vk.setElementAt(gen.gettable(request.getParameter("PT8")),14);
              vk.setElementAt(gen.gettable(request.getParameter("PT9")),15);
              vk.setElementAt(gen.gettable(request.getParameter("T14")),16);
              vk.setElementAt(gen.gettable(request.getParameter("T15")),17);
              vk.setElementAt(gen.gettable(request.getParameter("T16")),18);
            vk.setElementAt(gen.gettable(request.getParameter("T17")),19);
            vk.setElementAt(gen.gettable(request.getParameter("T18")),20);
            int hx=gen.getInt(request.getParameter("CS"));
            java.util.Vector tmp=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELSales") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp.addElement(request.getParameter("A"+m));
                  tmp.addElement(request.getParameter("B"+m));
                  tmp.addElement(request.getParameter("C"+m));
                  tmp.addElement(request.getParameter("D"+m));
                  if(gen.gettable(request.getParameter("E"+m)).equalsIgnoreCase("ON")) tmp.addElement("1");
                  else tmp.addElement("0");
                  tmp.addElement(request.getParameter("F"+m));
                  if(gen.gettable(request.getParameter("G"+m)).equalsIgnoreCase("ON")) tmp.addElement("1");
                  else tmp.addElement("0");
                  tmp.addElement(request.getParameter("H"+m));
                  tmp.addElement(request.getParameter("I"+m));
                  tmp.addElement(request.getParameter("Z"+m));
                  tmp.addElement(request.getParameter("J"+m));
                  tmp.addElement(request.getParameter("II"+m));
                }
            }
            sales=tmp;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddSales")){
                for(int m=0;m<12;m++){
                    if(m==3 ||m==5||m==7) sales.addElement("0");
                    else if(m==10) sales.addElement("1");
                    else if(m==0) sales.addElement(billto);
                    else if(m==9) sales.addElement(bdesc);
                    else  sales.addElement("");
                }
            }
            hx=gen.getInt(request.getParameter("CC"));
            java.util.Vector tmp1=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELCost") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp1.addElement(request.getParameter("K"+m));
                  tmp1.addElement(request.getParameter("L"+m));
                  tmp1.addElement(request.getParameter("M"+m));
                  tmp1.addElement(request.getParameter("N"+m));
                  tmp1.addElement(request.getParameter("O"+m));
                  if(gen.gettable(request.getParameter("P"+m)).equalsIgnoreCase("ON")) tmp1.addElement("1");
                  else tmp1.addElement("0");
                  tmp1.addElement(request.getParameter("Q"+m));
                  if(gen.gettable(request.getParameter("R"+m)).equalsIgnoreCase("ON")) tmp1.addElement("1");
                  else tmp1.addElement("0");
                  tmp1.addElement(request.getParameter("W"+m));
                  tmp1.addElement(request.getParameter("V"+m));
                  tmp1.addElement(request.getParameter("X"+m));
                  tmp1.addElement(request.getParameter("U"+m));
                  tmp1.addElement(request.getParameter("VV"+m));
                }
            }
            cost=tmp1;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddCost")){
                for(int m=0;m<13;m++){
                    if(m==4 ||m==6||m==8) cost.addElement("0");
                    else if(m==11) cost.addElement("1");
                    else if(m==0) cost.addElement(vendor);
                    else if(m==10) cost.addElement(vdesc);
                    else  cost.addElement("");
                }
            }
        }
        if(cost.size()==0){
            for(int m=0;m<13;m++){
                if(m==4 ||m==6||m==8) cost.addElement("0");
                else if(m==11) cost.addElement("1");
                else if(m==0) cost.addElement(vendor);
                else if(m==10) cost.addElement(vdesc);
                else  cost.addElement("");
            }
        }
        if(sales.size()==0){
                for(int m=0;m<12;m++){
                    if(m==3 ||m==5||m==7) sales.addElement("0");
                    else if(m==10) sales.addElement("1");
                    else if(m==0) sales.addElement(billto);
                    else if(m==9) sales.addElement(bdesc);
                    else  sales.addElement("");
                }
        }
       // System.out.println(",cost="+cost.size());
        String dtf=gen.getToday("dd-MM-yyyy");
        //if(request.getParameter("T2")!=null && gen.gettable(request.getParameter("T2")).length()>0) dtf=gen.gettable(request.getParameter("T2"));
        java.util.Vector rt=sgen.getDataQuery(conn,"LISTRATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),dtf,gen.gettable(ses.getAttribute("TxtErcode")),dtf,gen.gettable(ses.getAttribute("TxtErcode")),dtf,gen.gettable(ses.getAttribute("TxtErcode")),dtf});
        
        
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
        String accrual=Gen.gettable(request.getParameter("AT2"));
        if(!gen.gettable(ses.getAttribute("TxtLevel")).equalsIgnoreCase("1")){//khusus accounting
            for(int ms=0;ms<oldcost.size();ms+=15){//
                if(gen.gettable(oldcost.get(ms+14)).trim().length()>0){
                    view="disabled";
                }
                if(gen.gettable(oldcost.get(ms+5)).length()>0){//ada accrual
                    accrual=gen.gettable(oldcost.get(ms+5));
                }
            }
            if(view.length()==0){
              for(int ms=0;ms<oldsales.size();ms+=14){//
                  if(gen.gettable(oldsales.get(ms+13)).trim().length()>0){
                      view="disabled";
                  }
                if(gen.gettable(oldsales.get(ms+6)).length()>0){//ada accrual
                    accrual=gen.gettable(oldsales.get(ms+6));
                }
              }
            }
        }
%>

	<body class="no-skin" <%if(gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false") && Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){%>onload="window.close()"<%}else{%> onload="counttot()"<%}%>>
    <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
        <jsp:include page="menu.jsp" flush ="true"/>
    <%}%>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="jobdetailnew.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
								Job <%=msg%>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=8><b>Job Header Information</b><td></tr>
  								</thead>                
  								<tbody>
                                      <tr>
                                          <td>Date:</td><td nowrap><input name="T2"   class="input-medium date-picker"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(3)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i></td>
                                          <td>BL No:</td><td><input type="text" id="T6" size="15" maxlength="25" name="T6"  placeholder="BL No." value="<%=Gen.gettable(vk.get(4)).trim()%>" <%=view%>/></td>
                                          <td>2 BL No:</td><td><input type="text" id="T15" size="15" maxlength="25" name="T15"  placeholder="2 BL No." value="<%=Gen.gettable(vk.get(17)).trim()%>" <%=view%>/></td>
                                          <td>HBL No:</td><td><input type="text" id="T16" size="15" maxlength="25" name="T16"  placeholder="HBL No." value="<%=Gen.gettable(vk.get(18)).trim()%>" <%=view%>/></td>
                                      </tr>
                                      <tr>
                                          <td>Job No:</td><td nowrap>
                                          <%if(y1.length()>0 || gen.gettable(ses.getAttribute("TxtErcode")).trim().equalsIgnoreCase("L")){%>
                                          <input type="hidden" id="T1" maxlength="10" size="10" name="T1"  value="<%=y1%>" /><b><%=y1%></b>
                                          <%}else{%>
                                          <input type="text" id="T1" maxlength="10" size="10" name="T1"  placeholder="Job No" value="<%=y1%>" />
                                          <%}%>
                                          &nbsp;&nbsp;&nbsp; Sales Code:&nbsp;&nbsp;<input type="text" id="T3" maxlength="2" size="2" name="T3"  placeholder="" value="<%=Gen.gettable(vk.get(1)).trim()%>" <%=view%>/></td>
                                          <td >Voyage:</td><td nowrap Colspan=3><input type="text" id="T7" maxlength="50" size="50" name="T7"  placeholder="Voyage No." value="<%=Gen.gettable(vk.get(5)).trim()%>" <%=view%>/></td>
                                          <td>POL/POD:</td><td><input type="text" id="T17" size="15" maxlength="25" name="T17"  placeholder="POD" value="<%=Gen.gettable(vk.get(19)).trim()%>" <%=view%>/></td>
                                      </tr>
                                      <tr>
                                          <td >Mother Vessel:</td><td nowrap><input type="text" id="T18" maxlength="50" size="40" name="T18"  placeholder="Mother Vessel Name" value="<%=Gen.gettable(vk.get(20)).trim()%>" <%=view%>/></td>
                                          <td >Vessel Name:</td><td nowrap  Colspan=3><input type="text" id="T14" maxlength="50" size="50" name="T14"  placeholder="Vessel Name" value="<%=Gen.gettable(vk.get(16)).trim()%>" <%=view%>/></td>
                                          <td>Sales:</td><td><input type="text"  style="text-align:right;" id="T8" size="14" maxlength="14" name="T8"  value="<%=Gen.getNumberFormat(vk.get(8),0)%>" <%=view%>/></td>
                                      </tr>
                                      <tr>
                                          <td nowrap>Job Type:</td><td><select name="T4" <%=view%>>
                                          	<option value="EXP" <%if(Gen.gettable(vk.get(2)).trim().equalsIgnoreCase("EXP")) out.print("selected");%>>EXP</option>
                                          	<option value="IMP" <%if(Gen.gettable(vk.get(2)).trim().equalsIgnoreCase("IMP")) out.print("selected");%>>IMP</option>
                                              <option value="TAX" <%if(Gen.gettable(vk.get(2)).trim().equalsIgnoreCase("TAX")) out.print("selected");%>>TAX</option>
                                              <option value="BAN" <%if(Gen.gettable(vk.get(2)).trim().equalsIgnoreCase("BAN")) out.print("selected");%>>BAN</option>
                                              </select>
                                          </td>
                                          <td >Customer:</td><td nowrap  Colspan=3><input type="hidden" name="T5" value="<%=Gen.gettable(vk.get(6))%>"><input type="text" name="ST5" size="45" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(13)).trim()%>" disabled>
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('CUSTOMER','T5','ST5','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')"><%}%>
                                          </td>
                                          <td>Cost:</td><td nowrap><input type="text"  style="text-align:right;" id="T9" size="14" maxlength="14" name="T9"  value="<%=Gen.getNumberFormat(vk.get(9),0)%>" <%=view%>/></td>
                                      </tr>
                                      <tr>
                                          <td>Note:</td><td nowrap><textarea name="T13" rows=3 cols=40 tabindex="5"  <%=view%>><%=gen.gettable(vk.get(7)).trim()%></textarea></td>
                                          <td>Container No:</td><td   Colspan=3><textarea name="T11" rows=3 cols=50 tabindex="8"  <%=view%>><%=gen.gettable(vk.get(11)).trim()%></textarea></td>
                                          <td>Profit:</td><td nowrap><input type="text" id="T10"  style="text-align:right;" size="14" maxlength="14" name="T10"  value="<%=Gen.getNumberFormat(vk.get(10),0)%>" <%=view%>/></td>
  									</tr>
  								</tbody>
  							</table>
                         </div>
                        </div>
                        <div class="row">
                            <table id="Sales" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=10>Sales Information<input type="hidden" name="CS" value="<%=(sales.size()/12)%>"></th>
                    				</tr>
                					<tr>
                                        <th>BILL TO</th>
                                        <th>ACCOUNT</th>
                                        <th>CUR</th>
                                        <th>RATE</th>       
                                        <th>AMOUNT</th>
                                        <th>C</th>                                                                        
                                        <th>IDR</th>                                                                        
                                        <th>REMARKS</th>
                                        <th>MYOB</th>
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    int hit=1;
                                    for(int i=0;i<sales.size();i+=12){%>
                						<tr>
                							<td nowrap>
                          		              <input type="hidden" name="A<%=hit%>" value="<%=Gen.gettable(sales.get(i)).trim()%>">
                          		              <input type="text" name="Z<%=hit%>" size="25"  value="<%=Gen.gettable(sales.get(i+9)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('BILLTO','A<%=hit%>','Z<%=hit%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                              <%}%>
                                            </td>
                                            <td nowrap>
                                                <input type="text" name="B<%=hit%>"  size="4" value="<%=Gen.gettable(sales.get(i+1)).trim()%>" disabled>
                                                <%if(view.length()==0){%>
               				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ACCOUNTSALES','B<%=hit%>','','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                <%}%>
                                            </td>
                                            <td nowrap>
                                              <select name="C<%=hit%>" onchange="foundrate(prm1,J<%=hit%>,C<%=hit%>.value);countdet();" >
                                                    <option value="IDR" <%if(Gen.gettable(sales.get(i+2)).trim().equalsIgnoreCase("IDR")) out.print("selected");%>>IDR</option>
                                                	<option value="USD" <%if(Gen.gettable(sales.get(i+2)).trim().equalsIgnoreCase("USD")) out.print("selected");%>>USD</option>
                                                	<option value="SGD" <%if(Gen.gettable(sales.get(i+2)).trim().equalsIgnoreCase("SGD")) out.print("selected");%>>SGD</option>
                                                	<option value="CNY" <%if(Gen.gettable(sales.get(i+2)).trim().equalsIgnoreCase("CNY")) out.print("selected");%>>CNY</option>
                                                	<option value="EUR" <%if(Gen.gettable(sales.get(i+2)).trim().equalsIgnoreCase("EUR")) out.print("selected");%>>EUR</option>
                                              </select>    
                                            </td>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="J<%=hit%>" name="J<%=hit%>"    onkeyup="rate(D<%=hit%>.value,F<%=hit%>,C<%=hit%>.value,J<%=hit%>.value);counttot();" maxlength="10" size="7" value="<%=Gen.getNumberFormat(sales.get(i+10),0)%>" <%=view%>/>
                                                <%if(view.length()==0){%>
               				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLinkRate('RATECUR','J<%=hit%>','','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,'+C<%=hit%>.value+',','')">
                                                <%}%>
                                            </td>                                            
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="D<%=hit%>" name="D<%=hit%>" onkeyup="rate(D<%=hit%>.value,F<%=hit%>,C<%=hit%>.value,J<%=hit%>.value);counttot();" maxlength="15" size="10" value="<%=Gen.getNumberFormat(sales.get(i+3))%>" <%=view%>/>
                                            </td>
                                            <td nowrap><input type="checkbox" name="E<%=hit%>" value="ON" <%if(Gen.gettable(sales.get(i+4)).trim().equalsIgnoreCase("1")) out.print("checked");%>></td>
                							<td>
                                                <input type="text"   style="text-align:right;" id="F<%=hit%>" name="F<%=hit%>" maxlength="15" size="12" value="<%=Gen.getNumberFormat(sales.get(i+5),0)%>" <%=view%>/>
                                            </td nowrap>
                							<td nowrap>
                                                <input type="text" id="II<%=hit%>" name="II<%=hit%>" maxlength="30" size="20" value="<%=Gen.gettable(sales.get(i+11)).trim()%>" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input type="text" id="I<%=hit%>" name="I<%=hit%>" maxlength="10" size="8" value="<%=Gen.gettable(sales.get(i+8)).trim()%>" <%=view%>/>
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Sales','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=9></td><td><a href="javascript:subm('AddSales')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
                        </div>
                        <div class="row">
                            <table id="Sales" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=11>Cost Information<input type="hidden" name="CC" value="<%=(cost.size()/13)%>"></th>
                    				</tr>
                					<tr>
                                        <th>VENDOR</th>
                                        <th>ACCOUNT</th>
                                        <th>INVOICE</th>
                                        <th>CUR</th>
                                        <th>RATE</th>
                                        <th>AMOUNT</th>
                                        <th>C</th>                                                                        
                                        <th>IDR</th>                                                                        
                                        <th>REMARKS</th>
                                        <th>MYOB</th>
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    hit=1;
                                    for(int i=0;i<cost.size();i+=13){%>
                						<tr>
                							<td nowrap>
                          		              <input type="hidden" name="K<%=hit%>" value="<%=Gen.gettable(cost.get(i)).trim()%>">
                          		              <input type="text" name="X<%=hit%>" size="25"  value="<%=Gen.gettable(cost.get(i+10)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('VENDOR','K<%=hit%>','X<%=hit%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                              <%}%>
                                            </td>
                                            <td nowrap>
                                                <input type="text" name="L<%=hit%>"  size="4" value="<%=Gen.gettable(cost.get(i+1)).trim()%>" disabled>
                                                <%if(view.length()==0){%>
               				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ACCOUNTCOST','L<%=hit%>','','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                <%}%>
                                            </td>
                							<td nowrap>
                                                <input type="text" id="M<%=hit%>" name="M<%=hit%>" maxlength="30" size="10" value="<%=Gen.gettable(cost.get(i+2)).trim()%>" <%=view%>/>
                                            </td>
                                            <td nowrap>
                                              <select name="N<%=hit%>"  onchange="foundrate(prm1,U<%=hit%>,N<%=hit%>.value);countdet();" >
                                                    <option value="IDR" <%if(Gen.gettable(cost.get(i+3)).trim().equalsIgnoreCase("IDR")) out.print("selected");%>>IDR</option>
                                                	<option value="USD" <%if(Gen.gettable(cost.get(i+3)).trim().equalsIgnoreCase("USD")) out.print("selected");%>>USD</option>
                                                	<option value="SGD" <%if(Gen.gettable(cost.get(i+3)).trim().equalsIgnoreCase("SGD")) out.print("selected");%>>SGD</option>
                                                	<option value="CNY" <%if(Gen.gettable(cost.get(i+3)).trim().equalsIgnoreCase("CNY")) out.print("selected");%>>CNY</option>
                                                	<option value="EUR" <%if(Gen.gettable(cost.get(i+3)).trim().equalsIgnoreCase("EUR")) out.print("selected");%>>EUR</option>
                                              </select>    
                                            </td>
                							<td nowrap>
                                                <input type="text"  style="text-align:right;" id="U<%=hit%>" name="U<%=hit%>" maxlength="10"  onkeyup="rate(O<%=hit%>.value,Q<%=hit%>,N<%=hit%>.value,U<%=hit%>.value);counttot();" size="6" value="<%=Gen.getNumberFormat(cost.get(i+11),0)%>" <%=view%>/>
                                                <%if(view.length()==0){%>
               				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLinkRate('RATECUR','U<%=hit%>','','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,'+N<%=hit%>.value+',','')">
                                                <%}%>
                                            </td>                                            
                							<td nowrap>
                                                <input type="text"  style="text-align:right;"  id="O<%=hit%>" name="O<%=hit%>" maxlength="15"  onkeyup="rate(O<%=hit%>.value,Q<%=hit%>,N<%=hit%>.value,U<%=hit%>.value);counttot();" size="8" value="<%=Gen.getNumberFormat(cost.get(i+4))%>" <%=view%>/>
                                            </td>
                                            <td><input type="checkbox" name="P<%=hit%>" value="ON" <%if(Gen.gettable(cost.get(i+5)).trim().equalsIgnoreCase("1")) out.print("checked");%>></td>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="Q<%=hit%>" name="Q<%=hit%>" maxlength="15" size="12" value="<%=Gen.getNumberFormat(cost.get(i+6),0)%>" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input type="text" id="VV<%=hit%>" name="VV<%=hit%>" maxlength="30" size="20" value="<%=Gen.gettable(cost.get(i+12)).trim()%>" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input type="text" id="V<%=hit%>" name="V<%=hit%>" maxlength="10" size="8" value="<%=Gen.gettable(cost.get(i+9)).trim()%>" <%=view%>/>
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Cost','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=10></td><td><a href="javascript:subm('AddCost')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
						</div><!-- /.row -->
                      <%if(view.length()==0){%>
                        <div class="row" align=center>
                      		<button class="btn btn-info" type="button" onclick="setsave('1');">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                            <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>                            
                        		<button class="btn btn-info" type="button" onclick="onreturn();">
                        			<i class="ace-icon fa fa-return bigger-110"></i>
                        			Back
                        		</button>
                              <%if(!add.equalsIgnoreCase("true")){%>
                        		<button class="btn btn-info" type="button" onclick="onadd();">
                        			<i class="ace-icon fa fa-plus bigger-110"></i>
                        			Add New
                        		</button>
                              <%}%>
                            <%}%>
                        </div>
                        <%}%>
					</div><!-- /.page-content -->
                      <%if(view.length()==0){%>
                      
                      <div class="clearfix form-actions">
                      	<div class="col-md-offset-3 col-md-9">
                      	</div>
                      </div>
                        <%}%>
                    <input type="hidden" name="act" value="">
                    <input type="hidden" name="baris" value="">
                    <input type="hidden" name="add" value="<%=add%>">
                    <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>">
                    <input type="hidden" name="x" value="1">

                </form>                    
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

		<!--[if lte IE 8]>
		  <script src="assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="assets/js/jquery-ui.custom.min.js"></script>
		<script src="assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="assets/js/jquery.gritter.min.js"></script>
		<script src="assets/js/bootbox.js"></script>
		<script src="assets/js/jquery.easypiechart.min.js"></script>
		<script src="assets/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/jquery.hotkeys.index.min.js"></script>
		<script src="assets/js/bootstrap-wysiwyg.min.js"></script>
		<script src="assets/js/select2.min.js"></script>
		<script src="assets/js/spinbox.min.js"></script>
		<script src="assets/js/bootstrap-editable.min.js"></script>
		<script src="assets/js/ace-editable.min.js"></script>
		<script src="assets/js/jquery.maskedinput.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
        var prm1=new Array();
       <% for(int i =0;i<rt.size()/2;i++){
				out.println("prm1["+i+"] = new Array(2);");
				out.println("prm1["+i+"]["+0+"] = \""+Gen.gettable(rt.get(i*2))+"\";prm1["+i+"]["+1+"] = \""+Gen.getNumberFormat(rt.get((i*2)+1),0)+"\";");
	   }%>      

	function setradio(Parm,avalue)
	{
  		Parm.value = avalue;
        
	}
    function ondel(Parm){
        if(confirm("Delete Selected Record?","Delete")){
           document.BGA.act.value="DEL";
           document.BGA.S2.value=Parm;
            BGA.submit();
        }
    }
    function onreturn(){
        location.href="jobnew.jsp?tp=JOBNEW";
    }
    function onadd(){
        location.href="jobdetailnew.jsp?add=true&tp=<%=request.getParameter("tp")%>";
    }
    
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
	function setLinkRate(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&sort=2&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
      //*T1=[JobNo],[Seq],*T2=[TrxDate],*T3=[Acct],T5=[DebetKredit],T8=[RefNo1],*T7=[Code],*T6=[TypeJob],*T4=[JobStatus],[USD],[SGD],T9 AMT[IDR] ,T10[Rate],T11 CURR,[Comment],ST3=[Desc],T12[RefNo2],
//                                                            T13=16 [Vendor],T14=17 [BillTo],T15=18 [Customer],T16=[MYOBNO],T17=[MYOBAMT],T18=[MYOBSTATUS]

            function  setsave(Parm){
                if(Parm=="1"){
                  if(document.BGA.T2.value==""){
                      alert("Transaction Date must be filled!");
                  }else{
                     document.BGA.T1.disabled=false;
                     document.BGA.ST5.disabled=false;
                     <%
                     int hc=1;
                     for(int i=0;i<sales.size();i+=12){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.Z<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<cost.size();i+=13){%>
                        document.BGA.L<%=hc%>.disabled=false;
                        document.BGA.X<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
                }else{
                     document.B.act.value="Save";
                      B.submit();
                }
            }
            function  refresh(){                
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            function rate(Parm1,Parm2,Parm3,Parm4){
                if(Parm3=='IDR'){
                  Parm2.value=Parm1;
                }else{
                   Parm2.value=NumberFormat(Math.round(Digit(Parm1)*Digit(Parm4)));
                }
                counttot();
            }
            
        	function foundrate(ArrayName,Fieldname, Parm)
        	{
              
         	  for(var i = 0; i < ArrayName.length; i++){
              
         	     if (ArrayName[i][0] == Parm){           
                   Fieldname.value= ArrayName[i][1];
                   return;
                 }
              }              
              Fieldname.value="0";
        	}
            
            function counttot(){
                     var t1=0,pt1=0;
                     <%
                     int htc=1;
                     for(int i=0;i<sales.size();i+=12){%>
                        if(document.BGA.F<%=htc%>.value!='') t1+=Digit(document.BGA.F<%=htc%>.value);
                     <%htc++;
                     }%>
                     document.BGA.T8.value=NumberFormat(Math.round(t1));
                     var t2=0,pt2=0;
                     <%
                     htc=1;
                     for(int i=0;i<cost.size();i+=13){%>
                        if(document.BGA.Q<%=htc%>.value!='') t2+=Digit(document.BGA.Q<%=htc%>.value);
                     <%htc++;
                     }%>
                     var m=Math.round(t2);
                     document.BGA.T9.value=NumberFormat(m);
                     var px=t1-t2;
                     px=Math.round(px);
                     document.BGA.T10.value=NumberFormat(px);
            }
            function countdet(){
                     <%
                     htc=1;
                     for(int i=0;i<sales.size();i+=12){%>
                        if(document.BGA.C<%=htc%>.value!='IDR'){
                            document.BGA.F<%=htc%>.value=NumberFormat(Digit(document.BGA.D<%=htc%>.value)*Digit(document.BGA.J<%=htc%>.value));
                        }
                     <%htc++;
                     }%>
                     var t2=0,pt2=0;
                     <%
                     htc=1;
                     for(int i=0;i<cost.size();i+=13){%>
                        if(document.BGA.N<%=htc%>.value!='IDR'){
                            document.BGA.Q<%=htc%>.value=NumberFormat(Digit(document.BGA.U<%=htc%>.value)*Digit(document.BGA.O<%=htc%>.value));
                        }
                     <%htc++;
                     }%>
                     counttot();
            }
            function  ondel(Parm,Parm1){                
                     document.BGA.T1.disabled=false;
                     document.BGA.ST5.disabled=false;
                     <%
                     hc=1;
                     for(int i=0;i<sales.size();i+=12){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.Z<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<cost.size();i+=13){%>
                        document.BGA.L<%=hc%>.disabled=false;
                        document.BGA.X<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.baris.value=Parm1;
                     document.BGA.act.value="DEL"+Parm;
                      BGA.submit();
            }
              function Digit(num){
                 yes="";
                 for(i=0;i<num.length;i++)
                 {
                    if(num.charAt(i)!=","){
                       yes=yes+num.charAt(i);
                    }
                 }
                 return parseFloat(yes);
              }
              function NumberFormat(num){
              	str=num.toString();
                if(num<0){
                    str=str.substring(1,str.length);
                }
                if(str=='') return "0";
              	tts = str.indexOf(",");
              	if (tts!=-1) return str;
              	ttk = str.indexOf(".");
              	if(ttk==-1)ttk=str.length;
              	for(i=ttk-3;i>0;i-=4){
              		str=str.substring(0,i)+","+str.substring(i,str.length);
              		i++;
              	}
                if(num<0){
                    str="-"+str;
                }
              	return str;
              }
function RoundFloat(num,digit){
	str=num.toString();
	ttk = str.indexOf(".");
	var temp="";
	if(ttk!=-1){
		if(str.length-1-ttk>digit){
			temp=str.substring(0,ttk+1);
			des = parseInt(str.substring(ttk+1,ttk+1+digit));
			if(parseInt(str.charAt(ttk+digit+1))>4)des++;
			if(des<10)
			 temp += "0"+des.toString();
			else
			 temp += des.toString(); 
		}
		else{
			temp = str;
			for(i=str.length-1;i<ttk+digit;i++)temp+="0";
		}
	}
	else{		
		temp=str;
		if(digit>0)temp+=".";
		for(i=0;i<digit;i++)temp+="0";
	}
	return temp;
}
            
            function  subm(Parm){                
                     document.BGA.T1.disabled=false;
                     document.BGA.ST5.disabled=false;
                     <%
                     hc=1;
                     for(int i=0;i<sales.size();i+=12){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.Z<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<cost.size();i+=13){%>
                        document.BGA.L<%=hc%>.disabled=false;
                        document.BGA.X<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.act.value=Parm;
                      BGA.submit();
            }
			jQuery(function($) {
			
				var active_class = 'active';
				//editables on first profile page
				$.fn.editable.defaults.mode = 'inline';
				$.fn.editableform.loading = "<div class='editableform-loading'><i class='ace-icon fa fa-spinner fa-spin fa-2x light-blue'></i></div>";
			    $.fn.editableform.buttons = '<button type="submit" class="btn btn-info editable-submit"><i class="ace-icon fa fa-check"></i></button>'+
			                                '<button type="button" class="btn editable-cancel"><i class="ace-icon fa fa-times"></i></button>';    
				
				//editables 
				
				//text editable
			    $('#username')
				.editable({
					type: 'text',
					name: 'username'		
			    });
			
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
				$('#user-profile-3')
				.find('input[type=file]').ace_file_input({
					style:'well',
					btn_choose:'Change avatar',
					btn_change:null,
					no_icon:'ace-icon fa fa-picture-o',
					thumbnail:'large',
					droppable:true,
					
					allowExt: ['jpg', 'jpeg', 'png', 'gif'],
					allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
				})
				.end().find('button[type=reset]').on(ace.click_event, function(){
					$('#user-profile-3 input[type=file]').ace_file_input('reset_input');
				})
				.end().find('.date-picker').datepicker().next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
			
			
				$('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);
			
			
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
				
				//select2 editable
				var countries = [];
			    $.each({ "CA": "Canada", "IN": "India", "NL": "Netherlands", "TR": "Turkey", "US": "United States"}, function(k, v) {
			        countries.push({id: k, text: v});
			    });
			
				var cities = [];
				cities["CA"] = [];
				$.each(["Toronto", "Ottawa", "Calgary", "Vancouver"] , function(k, v){
					cities["CA"].push({id: v, text: v});
				});
				cities["IN"] = [];
				$.each(["Delhi", "Mumbai", "Bangalore"] , function(k, v){
					cities["IN"].push({id: v, text: v});
				});
				cities["NL"] = [];
				$.each(["Amsterdam", "Rotterdam", "The Hague"] , function(k, v){
					cities["NL"].push({id: v, text: v});
				});
				cities["TR"] = [];
				$.each(["Ankara", "Istanbul", "Izmir"] , function(k, v){
					cities["TR"].push({id: v, text: v});
				});
				cities["US"] = [];
				$.each(["New York", "Miami", "Los Angeles", "Chicago", "Wysconsin"] , function(k, v){
					cities["US"].push({id: v, text: v});
				});
				
				var currentValue = "NL";
                $('#example').DataTable();
			    $('#country').editable({
					type: 'select2',
					value : 'NL',
					//onblur:'ignore',
			        source: countries,
					select2: {
						'width': 140
					},		
					success: function(response, newValue) {
						if(currentValue == newValue) return;
						currentValue = newValue;
						
						var new_source = (!newValue || newValue == "") ? [] : cities[newValue];
						
						//the destroy method is causing errors in x-editable v1.4.6+
						//it worked fine in v1.4.5
						/**			
						$('#city').editable('destroy').editable({
							type: 'select2',
							source: new_source
						}).editable('setValue', null);
						*/
						
						//so we remove it altogether and create a new element
						var city = $('#city').removeAttr('id').get(0);
						$(city).clone().attr('id', 'city').text('Select City').editable({
							type: 'select2',
							value : null,
							//onblur:'ignore',
							source: new_source,
							select2: {
								'width': 140
							}
						}).insertAfter(city);//insert it after previous instance
						$(city).remove();//remove previous instance
						
					}
			    });
			
				$('#city').editable({
					type: 'select2',
					value : 'Amsterdam',
					//onblur:'ignore',
			        source: cities[currentValue],
					select2: {
						'width': 140
					}
			    });
			
			
				
				//custom date editable
				$('#signup').editable({
					type: 'adate',
					date: {
						//datepicker plugin options
						    format: 'yyyy/mm/dd',
						viewformat: 'yyyy/mm/dd',
						 weekStart: 1
						 
						//,nativeUI: true//if true and browser support input[type=date], native browser control will be used
						//,format: 'yyyy-mm-dd',
						//viewformat: 'yyyy-mm-dd'
					}
				})
			
			    $('#age').editable({
			        type: 'spinner',
					name : 'age',
					spinner : {
						min : 16,
						max : 99,
						step: 1,
						on_sides: true
						//,nativeUI: true//if true and browser support input[type=number], native browser control will be used
					}
				});
				
			
			    $('#login').editable({
			        type: 'slider',
					name : 'login',
					
					slider : {
						 min : 1,
						  max: 50,
						width: 100
						//,nativeUI: true//if true and browser support input[type=range], native browser control will be used
					},
					success: function(response, newValue) {
						if(parseInt(newValue) == 1)
							$(this).html(newValue + " hour ago");
						else $(this).html(newValue + " hours ago");
					}
				});
			
				$('#about').editable({
					mode: 'inline',
			        type: 'wysiwyg',
					name : 'about',
			
					wysiwyg : {
						//css : {'max-width':'300px'}
					},
					success: function(response, newValue) {
					}
				});
				
				
				
				// *** editable avatar *** //
				try {//ie8 throws some harmless exceptions, so let's catch'em
			
					//first let's add a fake appendChild method for Image element for browsers that have a problem with this
					//because editable plugin calls appendChild, and it causes errors on IE at unpredicted points
					try {
						document.createElement('IMG').appendChild(document.createElement('B'));
					} catch(e) {
						Image.prototype.appendChild = function(el){}
					}
			
					var last_gritter
					$('#avatar').editable({
						type: 'image',
						name: 'avatar',
						value: null,
						//onblur: 'ignore',  //don't reset or hide editable onblur?!
						image: {
							//specify ace file input plugin's options here
							btn_choose: 'Change Avatar',
							droppable: true,
							maxSize: 110000,//~100Kb
			
							//and a few extra ones here
							name: 'avatar',//put the field name here as well, will be used inside the custom plugin
							on_error : function(error_type) {//on_error function will be called when the selected file has a problem
								if(last_gritter) $.gritter.remove(last_gritter);
								if(error_type == 1) {//file format error
									last_gritter = $.gritter.add({
										title: 'File is not an image!',
										text: 'Please choose a jpg|gif|png image!',
										class_name: 'gritter-error gritter-center'
									});
								} else if(error_type == 2) {//file size rror
									last_gritter = $.gritter.add({
										title: 'File too big!',
										text: 'Image size should not exceed 100Kb!',
										class_name: 'gritter-error gritter-center'
									});
								}
								else {//other error
								}
							},
							on_success : function() {
								$.gritter.removeAll();
							}
						},
					    url: function(params) {
							// ***UPDATE AVATAR HERE*** //
							//for a working upload example you can replace the contents of this function with 
							//examples/profile-avatar-update.js
			
							var deferred = new $.Deferred
			
							var value = $('#avatar').next().find('input[type=hidden]:eq(0)').val();
							if(!value || value.length == 0) {
								deferred.resolve();
								return deferred.promise();
							}
			
			
							//dummy upload
							setTimeout(function(){
								if("FileReader" in window) {
									//for browsers that have a thumbnail of selected image
									var thumb = $('#avatar').next().find('img').data('thumb');
									if(thumb) $('#avatar').get(0).src = thumb;
								}
								
								deferred.resolve({'status':'OK'});
			
								if(last_gritter) $.gritter.remove(last_gritter);
								last_gritter = $.gritter.add({
									title: 'Avatar Updated!',
									text: 'Uploading to server can be easily implemented. A working example is included with the template.',
									class_name: 'gritter-info gritter-center'
								});
								
							 } , parseInt(Math.random() * 800 + 800))
			
							return deferred.promise();
							
							// ***END OF UPDATE AVATAR HERE*** //
						},
						
						success: function(response, newValue) {
						}
					})
				}catch(e) {}
				
				/**
				//let's display edit mode by default?
				var blank_image = true;//somehow you determine if image is initially blank or not, or you just want to display file input at first
				if(blank_image) {
					$('#avatar').editable('show').on('hidden', function(e, reason) {
						if(reason == 'onblur') {
							$('#avatar').editable('show');
							return;
						}
						$('#avatar').off('hidden');
					})
				}
				*/
			
				//another option is using modals
				$('#avatar2').on('click', function(){
					var modal = 
					'<div class="modal fade">\
					  <div class="modal-dialog">\
					   <div class="modal-content">\
						<div class="modal-header">\
							<button type="button" class="close" data-dismiss="modal">&times;</button>\
							<h4 class="blue">Change Avatar</h4>\
						</div>\
						\
						<form class="no-margin">\
						 <div class="modal-body">\
							<div class="space-4"></div>\
							<div style="width:75%;margin-left:12%;"><input type="file" name="file-input" /></div>\
						 </div>\
						\
						 <div class="modal-footer center">\
							<button type="submit" class="btn btn-sm btn-success"><i class="ace-icon fa fa-check"></i> Submit</button>\
							<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>\
						 </div>\
						</form>\
					  </div>\
					 </div>\
					</div>';
					
					
					var modal = $(modal);
					modal.modal("show").on("hidden", function(){
						modal.remove();
					});
			
					var working = false;
			
					var form = modal.find('form:eq(0)');
					var file = form.find('input[type=file]').eq(0);
					file.ace_file_input({
						style:'well',
						btn_choose:'Click to choose new avatar',
						btn_change:null,
						no_icon:'ace-icon fa fa-picture-o',
						thumbnail:'small',
						before_remove: function() {
							//don't remove/reset files while being uploaded
							return !working;
						},
						allowExt: ['jpg', 'jpeg', 'png', 'gif'],
						allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
					});
			
					form.on('submit', function(){
						if(!file.data('ace_input_files')) return false;
						
						file.ace_file_input('disable');
						form.find('button').attr('disabled', 'disabled');
						form.find('.modal-body').append("<div class='center'><i class='ace-icon fa fa-spinner fa-spin bigger-150 orange'></i></div>");
						
						var deferred = new $.Deferred;
						working = true;
						deferred.done(function() {
							form.find('button').removeAttr('disabled');
							form.find('input[type=file]').ace_file_input('enable');
							form.find('.modal-body > :last-child').remove();
							
							modal.modal("hide");
			
							var thumb = file.next().find('img').data('thumb');
							if(thumb) $('#avatar2').get(0).src = thumb;
			
							working = false;
						});
						
						
						setTimeout(function(){
							deferred.resolve();
						} , parseInt(Math.random() * 800 + 800));
			
						return false;
					});
							
				});
			
				
			
				//////////////////////////////
				$('#profile-feed-1').ace_scroll({
					height: '250px',
					mouseWheelLock: true,
					alwaysVisible : true
				});
			
				$('a[ data-original-title]').tooltip();
			
				$('.easy-pie-chart.percentage').each(function(){
				var barColor = $(this).data('color') || '#555';
				var trackColor = '#E2E2E2';
				var size = parseInt($(this).data('size')) || 72;
				$(this).easyPieChart({
					barColor: barColor,
					trackColor: trackColor,
					scaleColor: false,
					lineCap: 'butt',
					lineWidth: parseInt(size/10),
					animate:false,
					size: size
				}).css('color', barColor);
				});
			  
				///////////////////////////////////////////
			
				//right & left position
				//show the user info on right or left depending on its position
				$('#user-profile-2 .memberdiv').on('mouseenter touchstart', function(){
					var $this = $(this);
					var $parent = $this.closest('.tab-pane');
			
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $this.offset();
					var w2 = $this.width();
			
					var place = 'left';
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) place = 'right';
					
					$this.find('.popover').removeClass('right left').addClass(place);
				}).on('click', function(e) {
					e.preventDefault();
				});
			
			
				///////////////////////////////////////////
			
				////////////////////
				//change profile
				$('[data-toggle="buttons"] .btn').on('click', function(e){
					var target = $(this).find('input[type=radio]');
					var which = parseInt(target.val());
					$('.user-profile').parent().addClass('hide');
					$('#user-profile-'+which).parent().removeClass('hide');
				});
				
				
				
				/////////////////////////////////////
				$(document).one('ajaxloadstart.page', function(e) {
					//in ajax mode, remove remaining elements before leaving page
					try {
						$('.editable').editable('destroy');
					} catch(e) {}
					$('[class*=select2]').remove();
				});
			});
		</script>
	</body>
</html>
