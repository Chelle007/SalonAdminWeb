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
        String tp=gen.gettable(request.getParameter("tp"));
        String title=gen.gettable(request.getParameter("title"));
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
          //  System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        String msg="";

    String[] judul = null;
    String[] detailTp = null;
    String[] detailTitle = null;
    switch (tp) { // ubah sini
        case "S_CARDS":
            judul = new String[]{"C_ID", "Card_name", "Category", "Card_value", "Payment_grace_period", "Due_date_type"};
            detailTp = new String[]{"S_CARD_ALLOWED_ITEM", "S_CARD_ALLOWED_TREATMENT"};
            detailTitle = new String[]{"Allowed Items", "Allowed Treatments"};
            break;
        case "S_CARD_PACKAGE":
            judul = new String[]{"CP_ID", "Descriptions", "Member_category", "Price", "Effective_date", "Expired_date"};
            detailTp = new String[]{"S_CARD_PACKAGE_DETAIL"};
            detailTitle = new String[]{"CardPackage Detail"};
            break;
        case "S_TREATMENT":
            judul = new String[]{"T_ID", "Treatment_name"};
            detailTp = new String[]{"S_TREATMENT_ITEMS"};
            detailTitle = new String[]{"Items Used"};
            break;
    }

        String S1=Gen.gettable(request.getParameter("S1"));
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
                    java.util.Vector exist=sgen.getDataQuery(conn,"SALESMEMBER",new String[0]);
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
                      while(seq.length()<2){
                          seq="0"+seq;
                      }
                }else{
                    seq="01";
                }
                S1=pref+seq;//[SALES_DATE] ,[MEMBER_ID],[AGENT_ID],[CARD_ID],[TOTAL_PRICE],[TOTAL_DISCOUNT_AMOUNT], [REMARK],[CARD_PACKAGE_ID],sales_id)
                  if(msg.length()==0) msg=sgen.update(conn,"SALESADD",new String[]{gen.gettable(request.getParameter("T2")),memb,gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T9")),S1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESADD",S1+"|"});
            }else{//update
                if(msg.length()==0) msg=sgen.update(conn,"SALESUPDATE",new String[]{gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),
                gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T9")),S1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESUPDATE",S1+"|"});
            }
            if(msg.length()==0){
                if(msg.length()==0) msg=sgen.update(conn,"SALES1DELETE",new String[]{S1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES2DELETE",new String[]{S1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES3DELETE",new String[]{S1});
                if(msg.length()==0) msg=sgen.update(conn,"SALES4DELETE",new String[]{S1});
                int hx=gen.getInt(request.getParameter("CS"));
                String tod=gen.getToday("dd-MM-yyyy");
                for(int m=1;m<=hx;m++){
                    if(gen.gettable(request.getParameter("B"+m)).length()>0){
                        if(msg.length()==0 && S1.length()>0) msg=sgen.update(conn,"SALES1ADD",new String[]{m+"", gen.gettable(request.getParameter("B"+m)),gen.gettable(request.getParameter("D"+m)),gen.gettable(request.getParameter("E"+m)),S1});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES1ADD",S1+"|"+m+"|"+gen.gettable(request.getParameter("A"+m))+"|"+gen.gettable(request.getParameter("B"+m))+"|"});
                    }
                }

                if(msg.length()==0) {
                  hx=gen.getInt(request.getParameter("CC"));
                  for(int m=1;m<=hx;m++){
                      if(gen.gettable(request.getParameter("I"+m)).length()>0){
                          if(S1.trim().length()>0){
                            if(msg.length()==0) msg=sgen.update(conn,"SALES2ADD",new String[]{m+"",gen.gettable(request.getParameter("I"+m)),gen.gettable(request.getParameter("K"+m)),gen.gettable(request.getParameter("L"+m)),gen.gettable(request.getParameter("M"+m)),
                            gen.gettable(request.getParameter("N"+m)),gen.gettable(request.getParameter("O"+m)),gen.gettable(request.getParameter("P"+m)),S1});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES2ADD",S1+"|"+m+"|"+gen.gettable(request.getParameter("I"+m))+"|"});
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
                        if(gen.gettable(request.getParameter("X"+m)).length()>0){
                            inadd=true;
                            if(msg.length()==0 && S1.length()>0) msg=sgen.update(conn,"SALES3ADD",new String[]{m+"", gen.gettable(request.getParameter("X"+m)),gen.gettable(request.getParameter("U"+m)),gen.gettable(request.getParameter("V"+m)),S1});
                            if(msg.length()==0 ) msg=sgen.update(conn,"TREATMENTDETAILADD",new String[]{m+"",recc+"", gen.gettable(request.getParameter("X"+m)),gen.gettable(request.getParameter("XX"+m))});                           
                           //TREATMENT_RECORD_DETAIL_ID,TREATMENT_RECORD_ID,TREATMENT_ID,EMPLOYEE_ID)
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALES3ADD",S1+"|"+m+"|"+gen.gettable(request.getParameter("X"+m))+"|"});
                        }
                    }
                    if(inadd){
                      if(msg.length()==0) msg=sgen.update(conn,"TREATMENTADD",new String[]{recc+"", memb,gen.gettable(request.getParameter("T5")),S1,gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T7")),"0"});                           
                      if(msg.length()==0) msg=sgen.update(conn,"UPDATECOSTTREATMENT",new String[]{recc+"", S1,recc+""});                           
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
        
        String[] cond=new String[]{S1};
        java.util.Vector vk=sgen.getDataQuery(conn,tp,new String[0]); // TODO: sebelumnya cond diganti ke new String[0] is that okay?
        String add="false";
        if(vk.size()==0){
            for(int m=0;m<judul.length;m++)vk.addElement("");
            add="true";
        }

        int S1number = 0;
        for (int i=0;i<vk.size();i+=judul.length) {
            if (vk.get(i).toString().contains(S1)) {
                S1number = i;
            }
        }

        java.util.Vector ITEM=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) ITEM=sgen.getDataQuery(conn,"SALESDETAIL1",cond);
        java.util.Vector CARD=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) CARD=sgen.getDataQuery(conn,"SALESDETAIL2",cond);
        java.util.Vector TREAT=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) TREAT=sgen.getDataQuery(conn,"SALESDETAIL3",cond);
/*        java.util.Vector olditem=sgen.getDataQuery(conn,"SALESDETAIL1",cond);
        java.util.Vector oldcard=sgen.getDataQuery(conn,"SALESDETAIL2",cond);
        java.util.Vector oldtreat=sgen.getDataQuery(conn,"SALESDETAIL3",cond);
        ses.setAttribute("OLDCARD",oldcard);
        ses.setAttribute("OLDITEM",olditem);
        ses.setAttribute("OLDTREAT",oldtreat);*/

        // TODO: change this save statement
        if(request.getParameter("act")!=null && !Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){            //  [SALES_ID],[SALES_DATE] ,[MEMBER_ID],[AGENT_ID],[CARD_ID],[CARD_PACKAGE_ID],[TOTAL_PRICE],[TOTAL_DISCOUNT_AMOUNT], [REMARK],member_name ,agent_name,card_name,voucher_no  FROM 
              vk.setElementAt(S1,0);
              vk.setElementAt(gen.gettable(request.getParameter("T2")),1);
              vk.setElementAt(memb,2);
              vk.setElementAt(gen.gettable(request.getParameter("T4")),3);
              vk.setElementAt(gen.gettable(request.getParameter("T5")),4);
              vk.setElementAt(gen.gettable(request.getParameter("T7")),5);
              vk.setElementAt(gen.gettable(request.getParameter("T8")),6);
              vk.setElementAt(gen.gettable(request.getParameter("T6")),7);
              vk.setElementAt(gen.gettable(request.getParameter("ST3")),8);
              vk.setElementAt(gen.gettable(request.getParameter("ST4")),9);
              vk.setElementAt(gen.gettable(request.getParameter("ST5")),10);
              vk.setElementAt(gen.gettable(request.getParameter("ST1")),11);
              vk.setElementAt(gen.gettable(request.getParameter("T9")),12);
              vk.setElementAt(gen.gettable(request.getParameter("STX")),13);
             // vk.setElementAt(gen.gettable(request.getParameter("ST6")),14);
              vk.setElementAt(gen.gettable(request.getParameter("ST6")),15);
              vk.setElementAt(gen.gettable(request.getParameter("ST8")),16);
            int hx=gen.getInt(request.getParameter("CS"));
            java.util.Vector tmp=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELSales") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp.addElement(request.getParameter("A"+m));
                  tmp.addElement(request.getParameter("B"+m));
                  tmp.addElement(request.getParameter("C"+m));
                  tmp.addElement(request.getParameter("D"+m));
                  tmp.addElement(request.getParameter("E"+m));
                  tmp.addElement(request.getParameter("F"+m));
                }
            }
            ITEM=tmp;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddSales")){
              for(int m=0;m<6;m++){
                  if(m==3||m==4||m==5) ITEM.addElement("0");
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
                }
            }
            TREAT=tmp2;
           // System.out.println("TREAT="+TREAT.size()+","+gen.gettable(request.getParameter("act")));
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddTreat")){
              for(int m=0;m<8;m++){
                  if(m==4||m==5||m==3) TREAT.addElement("0");
                  else  TREAT.addElement("");
              }
            }
        }
        if(ITEM.size()==0){
              for(int m=0;m<6;m++){
                  if(m==3||m==4||m==5) ITEM.addElement("0");
                  else  ITEM.addElement("");
              }
        }
        if(CARD.size()==0){
              for(int m=0;m<9;m++){
                  if(m==4||m==5) CARD.addElement("0");
                  else  CARD.addElement("");
              }
        }
        if(TREAT.size()==0){
              for(int m=0;m<8;m++){
                  if(m==4||m==5||m==3) TREAT.addElement("0");
                  else  TREAT.addElement("");
              }
        }
       // System.out.println(",cost="+cost.size());
        String dtf=gen.getToday("dd-MM-yyyy");
        
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
%>

	<body class="skin-2" <%if(gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false") && Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){%>onload="window.close()"<%}else{%> onload="counttot()"<%}%>>
    <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
        <jsp:include page="menu.jsp" flush ="true"/>
    <%}%>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="master2detail.jsp?tp=<%=tp%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
								<%=title%> <%=msg%>
							</h1>
						</div><!-- /.page-header -->

						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=8><b><%=title%> Header Information</b><td></tr>
  								</thead>
  								<tbody>
  								    <tr>
                                        <td><%=judul[0]%>:</td><td colspan=3><input type="text" id="T1" size="35" maxlength="10" name="T1"  placeholder=<%=judul[0]%> value="<%=Gen.gettable(vk.get(S1number)).trim()%>" disabled/></td>
                                    </tr>
  								    <% for (int i=1; i<judul.length; i++) {
  								    %>
                                    <tr>
                                        <td><%=judul[i]%>:</td><td colspan=3><input type="text" id="T6" size="35" maxlength="40" name="T6"  placeholder=<%=judul[i]%> value="<%=Gen.gettable(vk.get(S1number+i)).trim()%>" <%=view%>/></td>
                                    </tr>
                                    <%}%>
  								</tbody>
  							</table>
                         </div>
                        </div>

                        <%
                        int hit=1;
                        for (int h=0; h<detailTp.length; h++) {
                            String[] judulDetail = null;
                            switch (detailTp[h]) { // ubah sini
                                case "S_TREATMENT_ITEMS":
                                    judulDetail = new String[]{"Item_id", "Quantity", "Purchase_price_per_unit", "Sales_price_per_unit"};
                                    break;
                                case "S_CARD_ALLOWED_ITEM":
                                    judulDetail = new String[]{"Item_id"};
                                    break;
                                case "S_CARD_ALLOWED_TREATMENT":
                                    judulDetail = new String[]{"Treatment_id"};
                                    break;
                                case "S_CARD_PACKAGE_DETAIL":
                                    judulDetail = new String[]{"Card_id", "Quantity"};
                                    break;
                            }

                            java.util.Vector detailData = sgen.getDataQuery(conn, detailTp[h], new String[]{S1});
                        %>
                        <div class="row">
                            <table id="item" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=<%=judulDetail.length+1%>><%=detailTitle[h]%> Information<input type="hidden" name="CS" value="<%=(detailData.size()/judulDetail.length+1)%>"></th>
                    				</tr>
                					<tr>
                					<% for (int j=0; j<judulDetail.length; j++) { %>
                                        <th><%=judulDetail[j]%></th>
                                    <%}%>
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    for(int i=0;i<detailData.size();i+=judulDetail.length+1){
                                    %>
                						<tr>
                							<td nowrap>
                               		          <input type="text" name="B<%=hit%>" size="5"  value="<%=Gen.gettable(detailData.get(i)).trim()%>" disabled>
                          		              <input type="text" name="C<%=hit%>" size="20"  value="<%=Gen.gettable(detailData.get(i+1)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink2('ITEMSELL','B<%=hit%>','C<%=hit%>','','','E<%=hit%>')">
                                              <%}%>
                                            </td>

                                            <%
                                            for (int j=i+2; j<i+judulDetail.length+1; j++) {
                                            %>
                                            <td>
                                                <input type="text" style="text-align:right;" id="D<%=hit%>" name="D<%=hit%>" maxlength="3" size="10" value="<%=Gen.getNumberFormat(detailData.get(j),0)%>" onchange="cc(D<%=hit%>,E<%=hit%>,F<%=hit%>)"  <%=view%>/>
                                            </td nowrap>
                                            <%}%>

                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Sales','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=<%=judulDetail.length%>></td><td><a href="javascript:subm('AddSales')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
                        </div>
                		<%}%>

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
        location.href="master2.jsp?tp=<%=tp%>";
    }
    function onadd(){
        location.href="master2detail.jsp?add=true&tp=<%=request.getParameter("tp")%>";
    }
    
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
	function setLink2(Pdata,FieldName,FieldName2,cond,listinactive,FieldName3){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&tt2="+FieldName3+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
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
                     document.BGA.ST5.disabled=false;
                     document.BGA.ST6.disabled=false;
                     document.BGA.STX.disabled=false;
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
                     for(int i=0;i<ITEM.size();i+=6){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
                        document.BGA.F<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     <%
                     hc=1;
                     for(int i=0;i<TREAT.size();i+=8){%>
                        document.BGA.X<%=hc%>.disabled=false;
                        document.BGA.Z<%=hc%>.disabled=false;
                        document.BGA.XX<%=hc%>.disabled=false;
                        document.BGA.ZZ<%=hc%>.disabled=false;
                        document.BGA.W<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
            }
            function  refresh(){                
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            function  ref(){     
                     document.BGA.act.value="Ref";
                      BGA.submit();
            }
            
            function counttot(){
                     var t1=0;
                     <%
                     int htc=1;
                     for(int i=0;i<ITEM.size();i+=6){%>
                        if(document.BGA.F<%=htc%>.value!='') t1+=Digit(document.BGA.F<%=htc%>.value);
                     <%htc++;
                     }%>
                     <%
                     htc=1;
                     for(int i=0;i<TREAT.size();i+=8){%>
                        if(document.BGA.W<%=htc%>.value!='') t1+=Digit(document.BGA.W<%=htc%>.value);
                     <%htc++;
                     }%>
                     <%
                     htc=1;
                     for(int i=0;i<CARD.size();i+=9){%>
                        if(document.BGA.M<%=htc%>.value!='') t1+=Digit(document.BGA.M<%=htc%>.value);
                     <%htc++;
                     }%>
                     document.BGA.T7.value=NumberFormat(Math.round(t1));
                     var m=0;
                     if(document.BGA.ST6.value!='') m=Digit(document.BGA.ST6.value);
                     var dis=m*t1/100;
                     document.BGA.T8.value=NumberFormat(dis);
            }
            function countdet(){
                     <%
                     htc=1;
                     for(int i=0;i<ITEM.size();i+=6){%>
                            document.BGA.F<%=htc%>.value=NumberFormat(Digit(document.BGA.D<%=htc%>.value)*Digit(document.BGA.E<%=htc%>.value));
                     <%htc++;
                     }%>
                     var t2=0,pt2=0;
                     <%
                     htc=1;
                     for(int i=0;i<TREAT.size();i+=8){%>
                             document.BGA.W<%=htc%>.value=NumberFormat(Digit(document.BGA.U<%=htc%>.value)*Digit(document.BGA.V<%=htc%>.value));
                     <%htc++;
                     }%>
                     counttot();
            }
            function cc(P1,P2,P3){
                          P3.value=NumberFormat(Digit(P1.value)*Digit(P2.value));
                          counttot();
            }
            function  ondel(Parm,Parm1){    
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
            
            function  subm(Parm){    
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
