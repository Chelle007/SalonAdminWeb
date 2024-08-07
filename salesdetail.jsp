<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
    <jsp:include page="title.jsp" flush ="true"/>
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
        com.ysoft.QueryClass query = new com.ysoft.QueryClass();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
          //  System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.util.Vector MSTCARD=sgen.getDataQuery(conn,"MSTCARD",new String[0]);

        String msg="";
        String y1=Gen.gettable(request.getParameter("S1"));
            String memb=gen.gettable(request.getParameter("T3"));
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
            conn.setAutoCommit(false);
            String t2=Gen.gettable(request.getParameter("T2"));//trxdate
            java.util.Vector vkst=gen.getElement('-',t2+"-");
            String yr=gen.gettable(vkst.get(2)).substring(2,4);
            String mth=gen.gettable(vkst.get(1));
            if(mth.length()==1) mth="0"+mth;
            if(Gen.gettable(request.getParameter("add")).equalsIgnoreCase("true")){//Umum
                if(gen.gettable(request.getParameter("T3")).length()==0){
                    java.util.Vector exist=sgen.getDataQuery(conn,"FINDMEMBER",new String[]{gen.gettable(request.getParameter("ST8"))});
                    if(exist.size()>0){
                        memb=gen.gettable(exist.get(0)).trim();//find member using contact_no
                    }else{
                        exist=sgen.getDataQuery(conn,"SALESMEMBER",new String[0]);
                        String pref="M";
                        String seq="";
                        if(exist.size()>0){
                            if(gen.gettable(exist.get(0)).trim().length()>0){   
                              String nextno=gen.gettable(exist.get(0));
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
                        memb=pref+seq;
                    }
                    if(msg.length()==0) msg=sgen.update(conn,"SALESMEMBERADD",new String[]{memb,gen.gettable(request.getParameter("ST3")),gen.gettable(request.getParameter("ST8"))});
                    if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESMEMBERADD",memb+"|"});
   
                }
                String jb=yr+mth+"%";
                java.util.Vector exist=sgen.getDataQuery(conn,"SALESMAX",new String[]{jb});
                String pref=yr+mth;
                String seq="";
                if(exist.size()>0){
                      String nextno=gen.gettable(exist.get(0));
                      int g=gen.getInt(nextno)+1;
                      seq=g+"";
                      while(seq.length()<4){
                          seq="000"+seq;
                      }
                }else{
                    seq="0001";
                }
                y1=pref+seq;//[SALES_DATE] ,[MEMBER_ID],[AGENT_ID],[CARD_ID],[TOTAL_PRICE],[TOTAL_DISCOUNT_AMOUNT], [REMARK],[CARD_PACKAGE_ID],sales_id)
                  if(msg.length()==0) msg=sgen.update(conn,"SALESADD",new String[]{gen.gettable(request.getParameter("T2")),memb,gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T10")),y1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESADD",y1+"|"});
            }else{//update
                if(msg.length()==0) msg=sgen.update(conn,"SALESUPDATE",new String[]{gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T10")),y1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESUPDATE",y1+"|"});
            }
            if(msg.length()==0){
                if(msg.length()==0) msg=sgen.update(conn,"SALES1DELETE",new String[]{y1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES2DELETE",new String[]{y1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES3DELETE",new String[]{y1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES4DELETE",new String[]{y1});//treatment
                if(msg.length()==0) msg=sgen.update(conn,"SALES5DELETE",new String[]{y1});//treatment detail
                if(msg.length()==0) msg=sgen.update(conn,"BANKREFDELETE",new String[]{y1});//bankcash
                
                //[Credit],[Debit],[TrxType],[RefNo],[Remarks] ,BANK,TrxDate,SEQ,refcode
                java.util.Vector exist=sgen.getDataQuery(conn,"BANKMAXSEQ",new String[]{gen.gettable(request.getParameter("T10")),gen.gettable(request.getParameter("T2"))});
                String seqmax="1";
                if(exist.size()>0){
                    seqmax=gen.gettable(exist.get(0)).trim();//
                }
                if(msg.length()==0) msg=sgen.update(conn,"BANKADD",new String[]{"0",gen.gettable(request.getParameter("T7")),"S","",gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T10")),gen.gettable(request.getParameter("T2")),seqmax,y1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"BANKADD",gen.gettable(request.getParameter("T2"))+"|"+seqmax+"|"});

                if(gen.gettable(request.getParameter("T3")).trim().length()>0 && gen.gettable(request.getParameter("T5")).trim().length()>0){                
                    if(msg.length()==0) msg=sgen.update(conn,"UPDATEUSINGDATE",new String[]{gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T5"))});
                }
                int hx=gen.getInt(request.getParameter("CS"));
                String tod=gen.getToday("dd-MM-yyyy");
                for(int m=1;m<=hx;m++){
                    if(gen.gettable(request.getParameter("B"+m)).length()>0){
                        if(msg.length()==0 && y1.length()>0) msg=sgen.update(conn,"SALES1ADD",new String[]{m+"", gen.gettable(request.getParameter("B"+m)),gen.gettable(request.getParameter("D"+m)),gen.gettable(request.getParameter("E"+m)),gen.gettable(request.getParameter("A"+m)),y1});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES1ADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("B"+m))+"|"});
                    }
                }

                if(msg.length()==0) {
                  hx=gen.getInt(request.getParameter("CC"));
                  for(int m=1;m<=hx;m++){
                      if(gen.gettable(request.getParameter("I"+m)).length()>0){
                          if(y1.trim().length()>0){
                            if(msg.length()==0) msg=sgen.update(conn,"SALES2ADD",new String[]{m+"",gen.gettable(request.getParameter("I"+m)),gen.gettable(request.getParameter("K"+m)),gen.gettable(request.getParameter("L"+m)),gen.gettable(request.getParameter("M"+m)),
                            gen.gettable(request.getParameter("N"+m)),gen.gettable(request.getParameter("O"+m)),gen.gettable(request.getParameter("P"+m)),y1});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES2ADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("I"+m))+"|"});
                          }
                      }
                  }                    
                }

                if(msg.length()==0) {
                    hx=gen.getInt(request.getParameter("CT"));
                    java.util.Vector exx=sgen.getDataQuery(conn,"TREATMENTRECORDMAX",new String[0]);
                    int recc=1;//TREATMENT_RECORD_ID,MEMBER_ID,CARD_ID,SALES_ID,TREATMENT_DATE,TOTAL_TREATMENT,TOTAL_MATERIAL
                    if(exx.size()>0) recc=gen.getInt(exx.get(0));
                    boolean inadd=false;
                     for(int m=1;m<=hx;m++){
                        if(gen.getInt(request.getParameter("U"+m))>0){
                      //  System.out.println("m="+m+",rec="+recc);
                            inadd=true;
                            if(msg.length()==0 && y1.length()>0) msg=sgen.update(conn,"SALES3ADD",new String[]{m+"", gen.gettable(request.getParameter("X"+m)),gen.gettable(request.getParameter("U"+m)),gen.gettable(request.getParameter("V"+m)),y1,gen.gettable(request.getParameter("VV"+m))});
                            if(msg.length()==0 ) msg=sgen.update(conn,"TREATMENTDETAILADD",new String[]{m+"",recc+"", gen.gettable(request.getParameter("X"+m)),gen.gettable(request.getParameter("XX"+m)),gen.gettable(request.getParameter("U"+m)),gen.gettable(request.getParameter("V"+m)),gen.gettable(request.getParameter("VV"+m))});                           
                           //TREATMENT_RECORD_DETAIL_ID,TREATMENT_RECORD_ID,TREATMENT_ID,EMPLOYEE_ID)
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES3ADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("X"+m))+"|"});
                        }
                    }
                    if(inadd){
                      if(msg.length()==0) msg=sgen.update(conn,"TREATMENTADD",new String[]{recc+"", memb,gen.gettable(request.getParameter("T5")),y1,gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T7")),"0",gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("ST1"))});                           
                      if(msg.length()==0) msg=sgen.update(conn,"UPDATECOSTTREATMENT",new String[]{recc+"",recc+""});                           
                    }
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
        
        String[] cond=new String[]{y1};
        java.util.Vector vk=sgen.getDataQuery(conn,"SALESHEADER",cond);
        String voucher=gen.gettable(request.getParameter("ST1"));
        String cardid=gen.gettable(request.getParameter("T5"));
        java.util.Vector existcard=sgen.getDataQuery(conn,"CARDMEMBER",new String[]{memb,cardid});
        String add="false";
        String cate="";
        if(existcard.size()>0) cate=gen.gettable(existcard.get(6)).trim();
        if(vk.size()==0){
            for(int m=0;m<19;m++)vk.addElement("");
            vk.setElementAt(gen.getToday("dd-MM-yyyy"),1);
            vk.setElementAt("0",5);
            vk.setElementAt("0",6);
            vk.setElementAt("CASH",17);
            vk.setElementAt("Cash",18);
            if(existcard.size()>0){           
                 vk.setElementAt(existcard.get(0),4);
                 vk.setElementAt(existcard.get(1),10);
                 vk.setElementAt(existcard.get(2),11);
                 vk.setElementAt(existcard.get(3),2);
                 vk.setElementAt(existcard.get(4),8);
                 memb=gen.gettable(existcard.get(3)).trim();
                 voucher=gen.gettable(existcard.get(2)).trim();
            }else{
                 vk.setElementAt(cardid,4);
                 vk.setElementAt(gen.gettable(request.getParameter("STB")),10);
                 vk.setElementAt(memb,2);
                 vk.setElementAt(gen.gettable(request.getParameter("ST3")),8);
                 vk.setElementAt(voucher,11);
            }
            add="true";
        }else{
            memb=gen.gettable(vk.get(2));
            voucher=gen.gettable(vk.get(11));
            cardid=gen.gettable(vk.get(4));            
        }
        java.util.Vector ITEM=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) ITEM=sgen.getDataQuery(conn,"SALESDETAIL1",cond);
        java.util.Vector CARD=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) CARD=sgen.getDataQuery(conn,"SALESDETAIL2",cond);
        java.util.Vector TREAT=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) TREAT=sgen.getDataQuery(conn,"SALESDETAIL3",cond);
        java.util.Vector MSTTREATMENT=sgen.getDataQuery(conn,"LISTTREATMENT1",new String[0]);
        if(cardid.length()>0){
            if(!cate.equalsIgnoreCase("MC"))
                MSTTREATMENT=sgen.getDataQuery(conn,"LISTTREATMENT2",new String[]{cardid});
            /*java.util.Vector dis=sgen.getDataQuery(conn,"LISTTREATMENT2",new String[]{cardid});
            for(int mm=0;mm<MSTTREATMENT.size();mm+=4){
                for(int mn=0;mn<dis.size();mn+=2){
                    if(gen.gettable(MSTTREATMENT.get(mm)).trim().equalsIgnoreCase(gen.gettable(dis.get(mn)).trim())){
                        MSTTREATMENT.setElementAt(gen.gettable(dis.get(mn+1)),mm+3);
                    }
                }
            }*/
        }
        
/*        java.util.Vector olditem=sgen.getDataQuery(conn,"SALESDETAIL1",cond);
        java.util.Vector oldcard=sgen.getDataQuery(conn,"SALESDETAIL2",cond);
        java.util.Vector oldtreat=sgen.getDataQuery(conn,"SALESDETAIL3",cond);
        ses.setAttribute("OLDCARD",oldcard);
        ses.setAttribute("OLDITEM",olditem);
        ses.setAttribute("OLDTREAT",oldtreat);*/
        if(request.getParameter("act")!=null && !Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){            //  [SALES_ID],[SALES_DATE] ,[MEMBER_ID],[AGENT_ID],[CARD_ID],[CARD_PACKAGE_ID],[TOTAL_PRICE],[TOTAL_DISCOUNT_AMOUNT], [REMARK],member_name ,agent_name,card_name,voucher_no  FROM 
              vk.setElementAt(y1,0);
              vk.setElementAt(gen.gettable(request.getParameter("T2")),1);
              vk.setElementAt(memb,2);
              vk.setElementAt(gen.gettable(request.getParameter("T4")),3);
              vk.setElementAt(gen.gettable(request.getParameter("T5")),4);
              vk.setElementAt(gen.gettable(request.getParameter("T7")),5);
              vk.setElementAt(gen.gettable(request.getParameter("T8")),6);
              vk.setElementAt(gen.gettable(request.getParameter("T6")),7);
              vk.setElementAt(gen.gettable(request.getParameter("ST3")),8);
              vk.setElementAt(gen.gettable(request.getParameter("ST4")),9);
              vk.setElementAt(gen.gettable(request.getParameter("STB")),10);
              vk.setElementAt(gen.gettable(request.getParameter("ST1")),11);
              vk.setElementAt(gen.gettable(request.getParameter("T9")),12);
              vk.setElementAt(gen.gettable(request.getParameter("STX")),13);
             // vk.setElementAt(gen.gettable(request.getParameter("ST6")),14);
              vk.setElementAt(gen.gettable(request.getParameter("ST6")),15);
              vk.setElementAt(gen.gettable(request.getParameter("ST8")),16);
              vk.setElementAt(gen.gettable(request.getParameter("T10")),17);
              vk.setElementAt(gen.gettable(request.getParameter("STA")),18);
            int hx=gen.getInt(request.getParameter("CS"));
            java.util.Vector tmp=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELSales") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp.addElement(""+m);
                  tmp.addElement(request.getParameter("B"+m));
                  tmp.addElement(request.getParameter("C"+m));
                  tmp.addElement(request.getParameter("D"+m));
                  tmp.addElement(request.getParameter("E"+m));                  
                  tmp.addElement(request.getParameter("F"+m));
                  tmp.addElement(request.getParameter("A"+m));
                  tmp.addElement(request.getParameter("G"+m));
                }
            }
            ITEM=tmp;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddSales")){
              for(int m=0;m<8;m++){
                  if(m==3||m==4||m==5||m==6||m==7) ITEM.addElement("0");
                  else  ITEM.addElement("");
              }
            }
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("ref") && gen.gettable(request.getParameter("T9")).length()>0 ){//ada isi package id
                java.util.Vector tmp1=new java.util.Vector();
                int jj=1;//master=MC, one use voucher=OUV, disc=D,repeatation=F
                java.util.Vector CC=sgen.getDataQuery(conn,"CARDPACKAGE",new String[]{gen.gettable(request.getParameter("T9"))});
                for(int i=0;i<CC.size();i+=9){// '',a.[CARD_ID],CARD_NAME,CATEGORY,CARD_VALUE,PRICE,PAYMENT_GRACE_PERIOD,DUE_DATE_TYPE,[QUANTITY]  FROM [CARD_PACK                    
                                                //A.[CARD_ID],CARD_NAME,[VOUCHER_NO],[CARD_VALUE],[TOPUP_PRICE],[USING_DATE],[EFFECTIVE_DATE],[EXPIRED_DATE] FROM [SALES_D
                    if(gen.gettable(CC.get(i+3)).trim().equalsIgnoreCase("F")){
                        String dst=gen.gettable(request.getParameter("T2"));
  
                        java.util.Vector v=gen.getElement('-',dst+"-");
                        if(dst.length()==0) v=gen.getElement('-',gen.getToday("dd-MM-yyyy")+"-");
                        int yrs=gen.getInt(v.get(2));
                        int mths=gen.getInt(v.get(1));

                        for(int s=0;s<gen.getInt(CC.get(i+4));s++){
                           if(gen.gettable(CC.get(i+7)).trim().equalsIgnoreCase("1")){//bulanan
                              if(mths==13){
                               yrs++;
                               mths=1;
                              }
                              int mthsn=mths+1;
                              int yrsn=yrs;
                              if(mthsn==13){
                                mthsn=1;
                                yrsn++;
                              }
                              int d=gen.getInt(v.get(0));
                              if(sgen.getLastDayofMonth(mths,yrs)<d){
                                  d=sgen.getLastDayofMonth(mths,yrs);
                              }
                              int dn=gen.getInt(v.get(0))-1;
                              if(dn==0){
                                 dn=sgen.getLastDayofMonth(mths,yrs);
                                 mthsn=mths;
                                 yrsn=yrs;
                              }
                              String st=d+"-"+mths+"-"+yrs;
                              if(mths<10)st=d+"-0"+mths+"-"+yrs;
                              String nx=dn+"-"+mthsn+"-"+yrsn;
                              if(mthsn<10)nx=dn+"-0"+mthsn+"-"+yrsn;
                              
                              tmp1.addElement(jj+"");
                              tmp1.addElement(CC.get(i+1));
                              tmp1.addElement(CC.get(i+2));
                              tmp1.addElement("");
                              tmp1.addElement("0");
                              tmp1.addElement("0");
                              tmp1.addElement("");
                              tmp1.addElement(st);
                              tmp1.addElement(nx);
                              jj++;
                              mths++;
                            }else{
                              tmp1.addElement(jj+"");
                              tmp1.addElement(CC.get(i+1));
                              tmp1.addElement(CC.get(i+2));
                              tmp1.addElement("");
                              tmp1.addElement("0");
                              tmp1.addElement("0");
                              tmp1.addElement("");
                              tmp1.addElement("");
                              tmp1.addElement("");
                              jj++;
                              //mths++;
                            }
                        }
                    }else{
                        tmp1.addElement(jj+"");
                        tmp1.addElement(CC.get(i+1));
                        tmp1.addElement(CC.get(i+2));
                        tmp1.addElement("");
                        if(gen.gettable(CC.get(i+3)).trim().equalsIgnoreCase("D")){
                            tmp1.addElement("0");
                        }else{
                            tmp1.addElement(CC.get(i+4));
                        }
                        if(gen.gettable(CC.get(i+3)).trim().equalsIgnoreCase("MC")){
                            tmp1.addElement(CC.get(i+5));
                        }else{
                            tmp1.addElement("0");
                        }
                        tmp1.addElement("");
                        tmp1.addElement("");
                        tmp1.addElement("");
                        jj++;
                    }
                }
                CARD=tmp1;
            }else{
                hx=gen.getInt(request.getParameter("CC"));
                java.util.Vector tmp1=new java.util.Vector();
                for(int m=1;m<=hx;m++){
                    if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELCard") && gen.getInt(request.getParameter("baris"))==m){
                    }else{
                      tmp1.addElement(request.getParameter("H"+m));
                      tmp1.addElement(request.getParameter("I"+m));
                      tmp1.addElement(request.getParameter("J"+m));
                      tmp1.addElement(request.getParameter("K"+m));
                      tmp1.addElement(request.getParameter("L"+m));
                      tmp1.addElement(request.getParameter("M"+m));
                      tmp1.addElement(request.getParameter("N"+m));
                      tmp1.addElement(request.getParameter("O"+m));
                      tmp1.addElement(request.getParameter("P"+m));
                    }
                }
                CARD=tmp1;
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddCard")){
                  for(int m=0;m<9;m++){
                      if(m==4||m==5) CARD.addElement("0");
                      else  CARD.addElement("");
                  }
                }
            }
            hx=gen.getInt(request.getParameter("CT"));
            java.util.Vector tmp2=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELTreat") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp2.addElement(request.getParameter("R"+m));
                  tmp2.addElement(request.getParameter("X"+m));
                  tmp2.addElement(request.getParameter("Z"+m));
                  tmp2.addElement(request.getParameter("U"+m));
                  tmp2.addElement(request.getParameter("V"+m));
                  tmp2.addElement(request.getParameter("W"+m));
                  tmp2.addElement(request.getParameter("XX"+m));
                  tmp2.addElement(request.getParameter("ZZ"+m));
                  tmp2.addElement(request.getParameter("VV"+m));
                  tmp2.addElement(request.getParameter("WW"+m));
                }
            }
        }
        if(ITEM.size()==0){
              for(int m=0;m<8;m++){
                  if(m==3||m==4||m==5||m==6) ITEM.addElement("0");
                  else  ITEM.addElement("");
              }
        }
        if(CARD.size()==0){
              for(int m=0;m<9;m++){
                  if(m==4||m==5) CARD.addElement("0");
                  else  CARD.addElement("");
              }
        }
       // System.out.println(",cost="+cost.size());
        String dtf=gen.getToday("dd-MM-yyyy");
    /*  apabila mau kalkulasi discount card 
         if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("Count") && Gen.gettable(request.getParameter("T5")).trim().length()>0){
          java.util.Vector mstc=sgen.getDataQuery(conn,"MSTCARDBYID",new String[]{ Gen.gettable(request.getParameter("T5")).trim()});
          int persen=0;
          int totdisc=0;
          if(!gen.gettable(mstc.get(0)).trim().equalsIgnoreCase("D")){
            totdisc=gen.getInt(mstc.get(1));
          }else{
            //persen=gen.getInt(mstc.get(1));
            java.util.Vector allow1=sgen.getDataQuery(conn,"MSTITEMDISC",new String[]{ Gen.gettable(request.getParameter("T5")).trim()});
            int tots=0;
            for(int ss=0;ss<ITEM.size();ss+=8){
                for(int st=0;st<allow1.size();st+=2){
                    System.out.println(allow1.get(st)+">>"+gen.gettable(ITEM.get(ss+1)).trim());
                    if(gen.gettable(ITEM.get(ss+1)).trim().equalsIgnoreCase(gen.gettable(allow1.get(st)).trim())){
                        totdisc+=gen.getInt(query.getDataInt(ITEM.get(ss+5)))*gen.getInt(allow1.get(st+1))/100;
                    }
                }
            }
            java.util.Vector allow2=sgen.getDataQuery(conn,"MSTTREATMENTDISC",new String[]{ Gen.gettable(request.getParameter("T5")).trim()});
            for(int ss=0;ss<TREAT.size();ss+=8){
                for(int st=0;st<allow2.size();st++){
                    System.out.println(allow2.get(st)+">>"+gen.gettable(TREAT.get(ss+1)).trim());
                    if(gen.gettable(TREAT.get(ss+1)).trim().equalsIgnoreCase(gen.gettable(allow2.get(st)).trim())){
                        tots+=gen.getInt(query.getDataInt(TREAT.get(ss+5)));
                    }
                }
            }
            totdisc=(int)Math.round(persen*tots/100);
          }
         vk.setElementAt(""+persen,15);
           vk.setElementAt(""+totdisc,6);
            
        }*/
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
        int GT=gen.getInt(vk.get(5))+gen.getInt(vk.get(6));
%>

	<body class="no-skin" <%if(gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false") && Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){%>onload="window.close()"<%}else{%> onload="counttot()"<%}%>>
    <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
        <jsp:include page="menu.jsp" flush ="true"/>
    <%}%>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="salesdetail.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
								Sales <%=msg%>&nbsp;&nbsp;&nbsp;&nbsp;	<%if(y1.length()>0){%><a href="javascript:jup()"><img width=10% height=10% src="image/invo.jpg" ></a><%}%>	
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=6><b>Sales Header Information</b><td></tr>
  								</thead>                
  								<tbody>
                                      <tr>
                                          <td>Sales ID:</td><td><input type="text" id="T1" size="15" maxlength="10" name="T1"  placeholder="Sales Id" value="<%=Gen.gettable(vk.get(0)).trim()%>" disabled/>
                                          Date:<input name="T2"   class="input-medium date-picker"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(1)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i></td>
                                          <td nowrap>Bank Id:</td><td nowrap ><input type="hidden" name="T10" value="<%=Gen.gettable(vk.get(17))%>"><input type="text" name="STA" size="15" maxlength="20"  value="<%=Gen.gettable(vk.get(18)).trim()%>" disabled>
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('BANK','T10','STA','','')"><%}%>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td>Remark:</td><td colspan=3><input type="text" id="T6" size="35" maxlength="40" name="T6"  placeholder="Remark" value="<%=Gen.gettable(vk.get(7)).trim()%>" <%=view%>/></td>
                                      </tr>
                                      <tr>
                                          <td >Member:</td><td nowrap><input type="hidden" name="T3" value="<%=Gen.gettable(vk.get(2))%>"><input type="text" name="ST3" size="25" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(8)).trim()%>" placeholder="Name">
                                          <input type="text" name="ST8" size="10" maxlength="15" tabindex="10"  value="<%=Gen.gettable(vk.get(16)).trim()%>" placeholder="Phone No">
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('MEMBER','T3','ST3','','')"><%}%>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td >Card Id:</td><td nowrap ><input type="hidden" name="T5" value="<%=Gen.gettable(vk.get(4))%>"><input type="text" name="STB" size="25" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(10)).trim()%>" disabled>
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink2('CARDMEMBERSALES','T5','STB',T3.value+',','','ST1')"><%}%>
                                          </td>
                                          <td >Voucher No:</td><td nowrap ><input type="hidden" name="ST6" size="5" value="<%=Gen.gettable(vk.get(15))%>" ><input type="text" name="ST1" size="20" value="<%=Gen.gettable(vk.get(11)).trim()%>" disabled> </td>
                                      </tr>
                                      <tr>
                                          <td >Card Package Id:</td><td nowrap ><input type="hidden" name="T9" value="<%=Gen.gettable(vk.get(12))%>"><input type="text" name="STX" size="25" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(13)).trim()%>" >
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink2('CARDPACKAGEMEMBER','T9','STX','','','T7')"><%}%>
                                          </td>
                                          <td >Agent:</td><td nowrap ><input type="hidden" name="T4" value="<%=Gen.gettable(vk.get(3))%>"><input type="text" name="ST4" size="25" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(9)).trim()%>" disabled>
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('AGENT','T4','ST4','','')"><%}%>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td>Total Gross Sales:</td><td nowrap><input type="text"  style="text-align:right;" id="GT" size="14" maxlength="14" name="GT"  value="<%=Gen.getNumberFormat(""+GT,0)%>" <%=view%> disabled/>&nbsp;&nbsp;Net:<input type="text"  style="text-align:right;" id="T7" size="14" maxlength="14" name="T7"  value="<%=Gen.getNumberFormat(vk.get(5),0)%>" <%=view%> disabled/></td>
                                          <td>Total Disc Amount:</td><td nowrap><input type="text"  style="text-align:right;" id="T8" size="14" maxlength="14" name="T8"  value="<%=Gen.getNumberFormat(vk.get(6),0)%>" <%=view%> onchange="applydisc()"/></td>
                                      </tr>
  								</tbody>
  							</table>
                         </div>
                        </div>
                        <div class="row">
                            <table id="treat" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=7>Treatment Information<input type="hidden" name="CT" value="<%=(MSTTREATMENT.size()/4)%>"></th>
                    				</tr>
                					<tr>
                                        <th>TREATMENT</th>
                                        <th>PERSONAL IN CHARGE</th>
                                        <th>QUANTITY</th>
                                        <th>PRICE</th>       
                                        <th>TOTAL</th>
                                        <th>DISC (%)</th>
                                        <th>DISC AMT</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    
                                    int hit=1,tf=0;
                                    int tt=0;
                                    for(int ii=0;ii<MSTTREATMENT.size();ii+=4){
                                        boolean print=false;
                                        for(int i=0;i<TREAT.size();i+=10){
                                            if(gen.gettable(TREAT.get(i+1)).trim().equalsIgnoreCase(gen.gettable(MSTTREATMENT.get(ii)).trim())){
                                                tt+=gen.getInt(query.getDataInt(TREAT.get(i+5)));
                                                print=true;
                                    %>
                    						<tr>
                    							<td nowrap>
                                                  <img title="<%=gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>" onclick="countqty(U<%=hit%>,W<%=hit%>,WW<%=hit%>,V<%=hit%>,VV<%=hit%>);ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>);" width=50 height=50 src=image/<%=gen.gettable(MSTTREATMENT.get(ii)).trim()%>.jpg ><%=Gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>
                              		              <input type="hidden" name="R<%=hit%>" value="<%=Gen.gettable(TREAT.get(i)).trim()%>">
                              		              <input type="hidden" name="X<%=hit%>" value="<%=Gen.gettable(MSTTREATMENT.get(ii)).trim()%>" >
                              		              <input type="hidden" name="Z<%=hit%>" value="<%=Gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>" >
                                                </td>
                    							<td nowrap>
                              		              <input type="text" name="XX<%=hit%>" size="4"  value="<%=Gen.gettable(TREAT.get(i+6)).trim()%>" disabled>
                              		              <input type="text" name="ZZ<%=hit%>" size="15"  value="<%=Gen.gettable(TREAT.get(i+7)).trim()%>" disabled>
                                                  <%if(view.length()==0){%>
                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('EMPLOYEETHERAPIST','XX<%=hit%>','ZZ<%=hit%>','','')">
                                                  <%}%>
                                                </td>
                    							<td>
                                                    <input type="text"   style="text-align:right;" id="U<%=hit%>" name="U<%=hit%>" maxlength="3" size="3" value="<%=Gen.getNumberFormat(TREAT.get(i+3),0)%>" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%>/>
                                                </td nowrap>
                    							<td>
                                                    <input type="text"   style="text-align:right;" id="V<%=hit%>" name="V<%=hit%>" maxlength="15" size="10" value="<%=Gen.getNumberFormat(TREAT.get(i+4),0)%>" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%>/>
                                                </td nowrap>
                    							<td nowrap>
                                                    <input type="text" name="W<%=hit%>" maxlength="10" size="8" value="<%=Gen.getNumberFormat(TREAT.get(i+5),0)%>" <%=view%> disabled/>
                                                </td>
                    							<td nowrap>
                                                    <input type="text" name="VV<%=hit%>" id="VV<%=hit%>" maxlength="10" size="2" value="<%=Gen.getNumberFormat(TREAT.get(i+8),0)%>" onchange="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%> />
                                                </td>
                    							<td nowrap>
                                                    <input type="text" name="WW<%=hit%>" maxlength="10" size="8" value="<%=Gen.getNumberFormat(TREAT.get(i+9),0)%>" <%=view%> disabled/>
                                                </td>
                       						</tr>
                                    <%      }//if ketemu
                                        }//end for loop treat
                                        if(!print){%>
                    						<tr>
                    							<td nowrap>
                                                  <img title="<%=gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>" width=50 height=50 src=image/<%=gen.gettable(MSTTREATMENT.get(ii)).trim()%>.jpg onclick="countqty(U<%=hit%>,W<%=hit%>,WW<%=hit%>,V<%=hit%>,VV<%=hit%>);ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>);"><%=Gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>
                              		              <input type="hidden" name="R<%=hit%>" value="<%=hit%>">
                              		              <input type="hidden" name="X<%=hit%>" value="<%=Gen.gettable(MSTTREATMENT.get(ii)).trim()%>" >
                              		              <input type="hidden" name="Z<%=hit%>" value="<%=Gen.gettable(MSTTREATMENT.get(ii+1)).trim()%>" >
                                                   </td>
                    							<td nowrap>
                              		              <input type="text" name="XX<%=hit%>" size="4"  value="<%=gen.gettable(request.getParameter("XX"+hit))%>" disabled>
                              		              <input type="text" name="ZZ<%=hit%>" size="15"  value="<%=gen.gettable(request.getParameter("ZZ"+hit))%>" disabled>
                                                  <%if(view.length()==0){%>
                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('EMPLOYEETHERAPIST','XX<%=hit%>','ZZ<%=hit%>','','')">
                                                  <%}%>
                                                </td>
                    							<td>
                                                    <input type="text"   style="text-align:right;" id="U<%=hit%>" name="U<%=hit%>" maxlength="3" size="3" value="<%=gen.getInt(request.getParameter("U"+hit))%>" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%>/>
                                                </td nowrap>
                    							<td>
                                                    <input type="text"   style="text-align:right;" id="V<%=hit%>" name="V<%=hit%>" maxlength="15" size="10" value="<%=gen.getNumberFormat(MSTTREATMENT.get(ii+2),0)%>" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%>/>
                                                </td nowrap>
                    							<td nowrap>
                                                    <input type="text" name="W<%=hit%>" maxlength="10" size="8" value="<%=gen.getInt(request.getParameter("W"+hit))%>" <%=view%> disabled/>
                                                </td>
                    							<td nowrap>
                                                    <input type="text" name="VV<%=hit%>" id="VV<%=hit%>" maxlength="10" size="2" value="<%=gen.getNumberFormat(MSTTREATMENT.get(ii+3),0)%>" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" onblur="ccdisc(U<%=hit%>,V<%=hit%>,W<%=hit%>,VV<%=hit%>,WW<%=hit%>)" <%=view%> />
                                                </td>
                    							<td nowrap>
                                                    <input type="text" name="WW<%=hit%>" maxlength="10" size="8" value="<%=gen.getInt(request.getParameter("WW"+hit))%>" <%=view%> disabled/>
                                                </td>
                       						</tr>
                                    <%  }//END PRINT   
                                        hit++;
                                    }%>
                                    <tr><td colspan=4></td>
                                     	<td nowrap>
                                              <input type="text" name="TT" maxlength="10" size="8" value="<%=Gen.getNumberFormat(tt+"",0)%>" <%=view%> disabled/>
                                          </td>
                                          <TD COLSPAN=3></TD>
                                    </tr>
                				</tbody>
                			</table>
                        </div>
                        <div class="row">
                            <table id="Sales" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=8>Card Information<input type="hidden" name="CC" value="<%=(CARD.size()/9)%>"></th>
                    				</tr>
                					<tr>
                                        <th>CARD ID</th>
                                        <th>VOUCHER NO/CARD NO</th>
                                        <th>CARD VALUE</th>
                                        <th>PRICE</th>
                                        <th>USING DATE</th>
                                        <th>EFFECTIVE DATE</th>                                                                        
                                        <th>EXPIRED DATE</th>                                                                        
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    hit=1;
                                    for(int i=0;i<CARD.size();i+=9){//[SALES_DETAILS_CARD_ID],A.[CARD_ID],CARD_NAME,[VOUCHER_NO],[CARD_VALUE],[TOPUP_PRICE],[USING_DATE
                                    %>
                						<tr>
                							<td nowrap>
                          		              <input type="hidden" name="H<%=hit%>" value="<%=Gen.gettable(CARD.get(i)).trim()%>">
                          		              <input type="text" name="I<%=hit%>" size="5"  value="<%=Gen.gettable(CARD.get(i+1)).trim()%>" disabled>
                          		              <input type="text" name="J<%=hit%>" size="20"  value="<%=Gen.gettable(CARD.get(i+2)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('CARD','I<%=hit%>','J<%=hit%>','','')">
                                              <%}%>
                                            </td>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="K<%=hit%>" name="K<%=hit%>" maxlength="10" size="10" value="<%=Gen.gettable(CARD.get(i+3)).trim()%>" <%=view%>/>
                                            </td >
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="L<%=hit%>" name="L<%=hit%>" maxlength="15" size="12" value="<%=Gen.getNumberFormat(CARD.get(i+4),0)%>" <%=view%>/>
                                            </td >
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="M<%=hit%>" name="M<%=hit%>" maxlength="15" size="12" value="<%=Gen.getNumberFormat(CARD.get(i+5),0)%>" <%=view%>/>
                                            </td >
                							<td nowrap>
                                                <input type="text" name="N<%=hit%>" maxlength="10" size="8" value="<%=Gen.gettable(CARD.get(i+6)).trim()%>" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input class="input-medium date-picker" type="text" name="O<%=hit%>" maxlength="10" size="8" value="<%=Gen.gettable(CARD.get(i+7)).trim()%>"  data-date-format="dd-mm-yyyy" <%=view%>/> 
                                            </td>
                							<td nowrap>
                                                <input class="input-medium date-picker" type="text" name="P<%=hit%>" maxlength="10" size="8" value="<%=Gen.gettable(CARD.get(i+8)).trim()%>"  data-date-format="dd-mm-yyyy" <%=view%>/> 
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Card','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=7></td><td><a href="javascript:subm('AddCard')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
						</div><!-- /.row -->
                        <div class="row">
                            <table id="item" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=7>Item Information<input type="hidden" name="CS" value="<%=(ITEM.size()/8)%>"></th>
                    				</tr>
                					<tr>
                                        <th>ITEM</th>
                                        <th>QUANTITY</th>
                                        <th>PRICE</th>       
                                        <th>TOTAL</th>
                                        <th>DISC (%)</th>  
                                         <th>DISC AMOUNT</th>      
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    hit=1;
                                    for(int i=0;i<ITEM.size();i+=8){
                                       tf+=gen.getInt(query.getDataInt(ITEM.get(i+5)));
                                    %>
                						<tr>
                							<td nowrap>
                          		              <input type="text" name="B<%=hit%>" size="5"  value="<%=Gen.gettable(ITEM.get(i+1)).trim()%>" disabled>
                          		              <input type="text" name="C<%=hit%>" size="20"  value="<%=Gen.gettable(ITEM.get(i+2)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink3('ITEMSELLALLW','B<%=hit%>','C<%=hit%>',T5.value+',','','E<%=hit%>','A<%=hit%>');">
                                              <%}%>
                                            </td>
                							<td>
                                                <input type="text"   style="text-align:right;" id="D<%=hit%>" name="D<%=hit%>" maxlength="3" size="10" value="<%=Gen.getNumberFormat(ITEM.get(i+3),0)%>" onchange="ccdisc(D<%=hit%>,E<%=hit%>,F<%=hit%>,A<%=hit%>,G<%=hit%>)"  <%=view%>/>
                                            </td nowrap>
                							<td>
                                                <input type="text"   style="text-align:right;" id="E<%=hit%>" name="E<%=hit%>" maxlength="15" size="12" value="<%=Gen.getNumberFormat(ITEM.get(i+4),0)%>" onchange="ccdisc(D<%=hit%>,E<%=hit%>,F<%=hit%>,A<%=hit%>,G<%=hit%>)"  <%=view%>/>
                                            </td nowrap>
                							<td nowrap>
                                                <input type="text" name="F<%=hit%>" maxlength="10" size="8" value="<%=Gen.getNumberFormat(ITEM.get(i+5),0)%>" <%=view%> disabled/>
                                            </td>
                							<td>
                                                <input type="text"   style="text-align:right;" id="A<%=hit%>" name="A<%=hit%>" maxlength="3" size="3" value="<%=Gen.getNumberFormat(ITEM.get(i+6),0)%>" onchange="ccdisc(D<%=hit%>,E<%=hit%>,F<%=hit%>,A<%=hit%>,G<%=hit%>)" onblur="ccdisc(D<%=hit%>,E<%=hit%>,F<%=hit%>,A<%=hit%>,G<%=hit%>)" <%=view%>/>
                                            </td>
                							<td>
                                                <input type="text"   style="text-align:right;" id="G<%=hit%>" name="G<%=hit%>" maxlength="15" size="10" value="<%=Gen.getNumberFormat(ITEM.get(i+7),0)%>" onchange="ccdisc(D<%=hit%>,E<%=hit%>,F<%=hit%>,A<%=hit%>,G<%=hit%>)"  <%=view%>/>
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Sales','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=3></td>
              							<td nowrap>
                                              <input type="text" name="TF" maxlength="10" size="8" value="<%=Gen.getNumberFormat(tf+"",0)%>" <%=view%> disabled/>
                                          </td>
                                          <td></td>
                                          <td></td>
                                        <td><a href="javascript:subm('AddSales')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
                        </div>
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
                    <input type="hidden" name="from" value="<%=gen.gettable(request.getParameter("from"))%>">
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
        <%if(gen.gettable(request.getParameter("from")).equalsIgnoreCase("CASHIER")){%>
        location.href="cashier.jsp?tp=CASHIER";
        <%}else{%>
        location.href="sales.jsp?tp=SALES";
        <%}%>
    }
    function onadd(){
        location.href="salesdetail.jsp?add=true&tp=<%=request.getParameter("tp")%>";
    }
	function jup(){
		url="invoice.jsp?tp=<%=request.getParameter("tp")%>&S1=<%=y1%>";
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
    
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
	function setLink2(Pdata,FieldName,FieldName2,cond,listinactive,FieldName3){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&tt2="+FieldName3+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
	function setLink3(Pdata,FieldName,FieldName2,cond,listinactive,FieldName3,P4){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&tt2="+FieldName3+"&tt3="+P4+"&T5="+document.BGA.T5.value+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
      //*T1=[JobNo],[Seq],*T2=[TrxDate],*T3=[Acct],T5=[DebetKredit],T8=[RefNo1],*T7=[Code],*T6=[TypeJob],*T4=[JobStatus],[USD],[SGD],T9 AMT[IDR] ,T10[Rate],T11 CURR,[Comment],ST3=[Desc],T12[RefNo2],
//                                                            T13=16 [Vendor],T14=17 [BillTo],T15=18 [Customer],T16=[MYOBNO],T17=[MYOBAMT],T18=[MYOBSTATUS]

            function  setsave(Parm){
                if(Parm=="1"){
                  if(document.BGA.T2.value==""){
                      alert("Sales Date must be filled!");
                  }else{
                     opendis();
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
                }else{
                     document.B.act.value="Save";
                      B.submit();
                }
            }
            function opendis(){
                     document.BGA.T1.disabled=false;
                     document.BGA.ST1.disabled=false;
                     document.BGA.ST3.disabled=false;
                     document.BGA.ST4.disabled=false;
                     document.BGA.STB.disabled=false;
                     document.BGA.ST6.disabled=false;
                     document.BGA.STX.disabled=false;
                     document.BGA.STA.disabled=false;
                     document.BGA.T7.disabled=false;
                      document.BGA.TF.disabled=false;
                      document.BGA.TT.disabled=false;
                      document.BGA.GT.disabled=false;
                     <%
                     int hc=1;
                     for(int i=0;i<CARD.size();i+=9){%>
                        document.BGA.I<%=hc%>.disabled=false;
                        document.BGA.J<%=hc%>.disabled=false;
                        document.BGA.N<%=hc%>.disabled=false;
                        document.BGA.O<%=hc%>.disabled=false;
                        document.BGA.P<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<ITEM.size();i+=8){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
                        document.BGA.F<%=hc%>.disabled=false;
                        document.BGA.G<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<MSTTREATMENT.size();i+=4){%>
                        document.BGA.X<%=hc%>.disabled=false;
                        document.BGA.Z<%=hc%>.disabled=false;
                        document.BGA.XX<%=hc%>.disabled=false;
                        document.BGA.ZZ<%=hc%>.disabled=false;
                        document.BGA.W<%=hc%>.disabled=false;
                        document.BGA.WW<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
            }
            function countqty(Q1,Q2,Q3,P1,P2){   
                Q1.value=NumberFormat(Digit(Q1.value)+1);
                var t=0;
                t=(Digit(Q1.value)*Digit(P1.value));
                Q2.value=NumberFormat(t);
                var d=t*Digit(P2.value)/100;
                Q3.value=NumberFormat(Math.round(d));
                 counttot();
            }
            
            function  refresh(){                
                     opendis();            
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            function  disc(){     
                     opendis();            
                     document.BGA.act.value="Count";
                      BGA.submit();
            }
            function  ref(){     
                     opendis();            
                     document.BGA.act.value="Ref";
                      BGA.submit();
            }
            function applydisc(){
                    var t=0;
                    if(document.BGA.T7.value!='' && document.BGA.T8.value!='') t=Digit(document.BGA.T7.value)-Digit(document.BGA.T8.value);
                    document.BGA.T7.value=NumberFormat(Math.round(t));
            }
            function countD(P1,P2,P3){             
                   var t=0;
                   t=Digit(P1.value)*Digit(P2.value)/100;
                    P3.value=NumberFormat(Math.round(t));
            }
            function counttot(){
                     var t1=0,d1=0;
                     <%
                     int htc=1;
                     for(int i=0;i<ITEM.size();i+=8){%>
                        if(document.BGA.F<%=htc%>.value!='') t1+=Digit(document.BGA.F<%=htc%>.value);
                         if(document.BGA.G<%=htc%>.value!='') d1+=Digit(document.BGA.G<%=htc%>.value);
                     <%htc++;
                     }%>
                      document.BGA.TF.value=NumberFormat(Math.round(t1));
                      var t2=0;
                     <%
                     htc=1;
                     
                     for(int i=0;i<MSTTREATMENT.size();i+=4){%>
                        if(document.BGA.W<%=htc%>.value!=''){
                             t1+=Digit(document.BGA.W<%=htc%>.value);
                             t2+=Digit(document.BGA.W<%=htc%>.value);
                        }
                        if(document.BGA.WW<%=htc%>.value!='') d1+=Digit(document.BGA.WW<%=htc%>.value);
                     <%htc++;
                     }%>
                      document.BGA.TT.value=NumberFormat(Math.round(t2));
                     <%
                     htc=1;
                     for(int i=0;i<CARD.size();i+=9){%>
                        if(document.BGA.M<%=htc%>.value!='') t1+=Digit(document.BGA.M<%=htc%>.value);
                     <%htc++;
                     }%>
                      document.BGA.GT.value=NumberFormat(Math.round(t1));
                     document.BGA.T8.value=NumberFormat(d1);
                     t1=t1-Digit(document.BGA.T8.value);
                     document.BGA.T7.value=NumberFormat(Math.round(t1));
            }
            function cc(P1,P2,P3){
                          P3.value=NumberFormat((Digit(P1.value)*Digit(P2.value)));
                          counttot();
            }
            function ccdisc(P1,P2,P3,P4,P5){
                        var t=0;
                        t=Digit(P1.value)*Digit(P2.value);
                        P3.value=NumberFormat(Math.round(t));
                        var dis=Digit(P4.value)*t/100;
                        P5.value=NumberFormat(Math.round(dis));
                        counttot();
            }
            function ondel(Parm,Parm1){    
                     opendis();            
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
            
            function subm(Parm){    
                     opendis();            
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
			
				$('#Sales').find('.date-picker').datepicker().next().on(ace.click_event, function(){
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
