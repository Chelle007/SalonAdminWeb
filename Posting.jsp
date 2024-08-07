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
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
         String msg="";
         
         //x=1 save account;x=2 save fix,x=3 posting,x=4 unpost
        if(Gen.gettable(request.getParameter("x")).equalsIgnoreCase("2")){
              conn.setAutoCommit(false);            
               String y10=gen.gettable(request.getParameter("Y10"));
               String y11=gen.gettable(request.getParameter("Y11"));
              msg=sgen.update(conn,"FIXGLDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
              if(msg.length()==0) msg=sgen.update(conn,"TRXFIXGLDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
              int hx=gen.getInt(request.getParameter("H"));
              for(int m=1;m<=hx;m++){//
                  String amt=gen.gettable(request.getParameter("E"+m));
                  String acct1=gen.gettable(request.getParameter("A"+m));
                  String acct2=gen.gettable(request.getParameter("C"+m));
                  String d=gen.gettable(request.getParameter("F"+m));
                  if(gen.getReleaseNumberFormat(amt)!=0 && acct1.length()>0 && acct2.length()>0){
                       if(msg.length()==0) msg=sgen.update(conn,"FIXGLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct1,acct2,amt});
                       if(msg.length()==0) msg=sgen.update(conn,"TRXFIXGLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct1,acct2,amt,d,y11,y10});
                  }              
               }
               if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"FIXGLADD",y11+"|"+y10+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Save Fix Ledger Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Save Fix Ledger Successfully)";
                }     
                conn.setAutoCommit(true);             
          }else if(Gen.gettable(request.getParameter("x")).equalsIgnoreCase("3")){
              conn.setAutoCommit(false);            
               String y10=gen.gettable(request.getParameter("Y10"));
               String y11=gen.gettable(request.getParameter("Y11"));
              String prevy=y11,prevm=(gen.getInt(y10)-1)+"";
               
              if(y10.equalsIgnoreCase("1")){
                prevy=(gen.getInt(prevy)-1)+"";
                prevm="12";
              }
              java.util.Vector dta=(java.util.Vector)ses.getAttribute("GL");
              String mth=y10;
              if(mth.length()==1)mth="0"+mth;
              int SEQ=1;
              for(int sm=0;sm<dta.size();sm+=15){
                String d=gen.gettable(dta.get(sm));
                String se=gen.gettable(dta.get(sm+1));
                String no=gen.gettable(dta.get(sm+2));
                String ad=gen.gettable(dta.get(sm+3));
                String add=gen.gettable(dta.get(sm+4)).trim();
                String ac=gen.gettable(dta.get(sm+5));
                String acd=gen.gettable(dta.get(sm+6)).trim();
                String cc=gen.gettable(dta.get(sm+7));
                String amt=gen.gettable(dta.get(sm+8));
                String ref1=gen.gettable(dta.get(sm+9));
                String rm=gen.gettable(dta.get(sm+10));
                String rate=gen.gettable(dta.get(sm+11));
                String tps=gen.gettable(dta.get(sm+12));
                String ori=gen.gettable(dta.get(sm+13));
                if(ac.equalsIgnoreCase(ad)){
                    continue;
                }
                String yr=y11.substring(2);
                
                String xGLID=SEQ+"";
                String GLID=SEQ+"";
                for(int m=xGLID.length();m<5;m++){
                    GLID="0"+GLID;
                }
                GLID=yr+mth+GLID;
                //[ErCode] ,[GLId],[TrxDate],curr,[Remarks],Trxtype,Refno
                if(msg.length()==0) msg=sgen.update(conn,"GLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,d,cc,rm,tps,ref1});
                
                //[ErCode] ,[GLId],[AcctNo],Debet,Credit,Rate,IDrDebet,IDrCredit,jobno,[note1],note2
                if(cc.trim().equalsIgnoreCase("IDR")){
                    if(gen.getformatdouble(ori)==0){
                        ori=amt;
                    }
                }
                                
                String[] xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,ad,ori,"0",rate,amt,"0",no,add,""};
                if(tps.equalsIgnoreCase("BANK")) xc[8]="";
                //for(int mm=0;mm<xc.length;mm++) System.out.print(xc[mm]+"|");
                if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);
                
                xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,ac,"0",ori,rate,"0",amt,no,acd,""};
                if(tps.equalsIgnoreCase("BANK")) xc[8]="";
                //for(int mm=0;mm<xc.length;mm++) System.out.print(xc[mm]+"|");                         
                if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);
                SEQ++;
                if(tps.equalsIgnoreCase("BANK")){
                    if(msg.length()==0) msg=sgen.update(conn,"BANKGL",new String[]{GLID,gen.gettable(ses.getAttribute("TxtErcode")),no,d,se});
                }else if(tps.startsWith("COST")){
                    if(msg.length()==0) msg=sgen.update(conn,"COSTGL",new String[]{GLID,gen.gettable(ses.getAttribute("TxtErcode")),no,se,ad});
                }else if(tps.equalsIgnoreCase("SALES")){
                    if(msg.length()==0) msg=sgen.update(conn,"SALESGL",new String[]{GLID,gen.gettable(ses.getAttribute("TxtErcode")),no,se,ac});
                }
              }
              java.util.Vector balance=sgen.getDataQuery(conn,"ACCOUNTBALANCE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),prevy,prevm,gen.gettable(ses.getAttribute("TxtErcode"))});
              java.util.Vector balC=sgen.getDataQuery(conn,"ACCOUNTBALANCEORIC",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
              java.util.Vector balD=sgen.getDataQuery(conn,"ACCOUNTBALANCEORID",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
              java.util.Vector fix=sgen.getDataQuery(conn,"FIXLEDGERMONTH",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
              
              for(int s=0;s<balance.size();s+=3){
                  String acct=gen.gettable(balance.get(s));
                  //String bal=gen.gettable(balance.get(s+2));
                  String dd="0",cr="0";
                  for(int ss=0;ss<balD.size();ss+=2){
                      if(gen.gettable(balance.get(s)).trim().equalsIgnoreCase(gen.gettable(balD.get(ss)).trim())){
                          dd=gen.gettable(balD.get(ss+1));
                          break;
                      }
                  }
                  for(int ss=0;ss<balC.size();ss+=2){
                      if(gen.gettable(balance.get(s)).trim().equalsIgnoreCase(gen.gettable(balC.get(ss)).trim())){
                          cr=gen.gettable(balC.get(ss+1));
                          break;
                      }
                  }
                  double bal=gen.getformatdouble(dd)-gen.getformatdouble(cr);
                  if(acct.startsWith("1")||acct.startsWith("2")||acct.startsWith("3")){
                    bal=gen.getformatdouble(balance.get(s+2))+gen.getformatdouble(dd)-gen.getformatdouble(cr);
                  }
                  for(int sm=0;sm<fix.size();sm+=6){
                    if(gen.gettable(fix.get(sm)).trim().equalsIgnoreCase(acct.trim())){
                        bal+=gen.getformatdouble(fix.get(sm+4));
                    }
                    if(gen.gettable(fix.get(sm+2)).trim().equalsIgnoreCase(acct.trim())){
                        bal-=gen.getformatdouble(fix.get(sm+4));
                    }                    
                  }
                  if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct,y11,y10,bal+""});
              }
              String nextm=(gen.getInt(y10)+1)+"",nexty=y11;
              if(nextm.equalsIgnoreCase("13")){
                nexty=(gen.getInt(nexty)+1)+"";
                nextm="1";
              }
              if(msg.length()==0) msg=sgen.update(conn,"SETCURRENTGL",new String[]{nextm,nexty,gen.gettable(ses.getAttribute("TxtErcode"))});
               if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"POSTINGGL",y11+"|"+y10+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Posting Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Posting Successfully)";
                }     
                conn.setAutoCommit(true);             
          }
         
          java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         String y10=gen.gettable(request.getParameter("Y10"));
         String y11=gen.gettable(request.getParameter("Y11"));
         String crntyear="",crntmonth="";
         if(request.getParameter("Y10")==null||gen.gettable(request.getParameter("x")).equalsIgnoreCase("3")||gen.gettable(request.getParameter("x")).equalsIgnoreCase("4")){ 
            y10=gen.gettable(userdef.get(0));
            y11=gen.gettable(userdef.get(1));
         }
         if(userdef.size()>0){
            crntmonth=gen.gettable(userdef.get(0));
            crntyear=gen.gettable(userdef.get(1));

         }
         String S1=gen.gettable(request.getParameter("S1"));
         String S2=gen.gettable(request.getParameter("S2"));
         
          String prevy=y11,prevm=(gen.getInt(y10)-1)+"";
          String mth=y10;
          if(mth.length()==1)mth="0"+mth;
           
          if(y10.equalsIgnoreCase("1")){
            prevy=(gen.getInt(prevy)-1)+"";
            prevm="12";
          }
          if(request.getParameter("S1")==null){
            S1=prevm;
            S2=prevy;
          }
          
         String[] judul=new String[]{"GLID","DATE","CURRENCY","REMARK","TRXTYPE","REF. NO."};
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
            combo2.addElement(y11);
          }
          
          java.util.Vector balance=sgen.getDataQuery(conn,"ACCOUNTBALANCE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),prevy,prevm,gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector balanceC=sgen.getDataQuery(conn,"ACCOUNTBALANCEC",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
          java.util.Vector balanceD=sgen.getDataQuery(conn,"ACCOUNTBALANCED",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
          String trx=sgen.getLastDayofMonth(gen.getInt(y10),gen.getInt(y11))+"-"+mth+"-"+y11;
          java.util.Vector vkrate=sgen.getDataQuery(conn,"LISTRATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx,gen.gettable(ses.getAttribute("TxtErcode")),trx});
          String title="General Ledger";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10};
          java.util.Vector post=sgen.getDataQuery(conn,"POSTGL",cond);
          
          java.util.Vector debtor=sgen.getDataQuery(conn,"ACCTDEBTOR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector creditor=sgen.getDataQuery(conn,"ACCTCREDITOR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector acctsales=sgen.getDataQuery(conn,"ACCTSALES",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector acctcost=sgen.getDataQuery(conn,"ACCTCOST",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector vpost=post;
          for(int s=0;s<post.size();s+=15){//[trxdate],[SEQ],[KEYT],[AcctDebit],db.[Description],[AcctCredit],mst_account.[description],[curr],[Amount],[my_e],remarks,rate,[TP],netamt 
                if(gen.gettable(post.get(s+12)).trim().equalsIgnoreCase("BANK") && (gen.gettable(post.get(s+14)).trim().startsWith("COST")||gen.gettable(post.get(s+14)).trim().startsWith("SALES"))){
                    for(int m=0;m<acctsales.size();m+=2){                        
                        if(gen.gettable(acctsales.get(m)).trim().equalsIgnoreCase(gen.gettable(post.get(s+5)).trim())){
                            String cu=gen.gettable(post.get(s+7)).trim();   
                            for(int mm=0;mm<debtor.size();mm+=2){
                              if(gen.gettable(debtor.get(mm+1)).trim().indexOf(cu)>0){
                                  post.setElementAt(gen.gettable(debtor.get(mm)),s+5);
                                  post.setElementAt(gen.gettable(debtor.get(mm+1)).trim(),s+6);
                              }
                            } 
                        }
                    }
                    for(int m=0;m<acctcost.size();m+=2){                        
                        if(gen.gettable(acctcost.get(m)).trim().equalsIgnoreCase(gen.gettable(post.get(s+3)).trim())){
                            String cu=gen.gettable(post.get(s+7)).trim();   
                            for(int mm=0;mm<creditor.size();mm+=2){
                              if(gen.gettable(creditor.get(mm+1)).trim().indexOf(cu)>0){
                                  post.setElementAt(gen.gettable(creditor.get(mm)),s+3);
                                  post.setElementAt(gen.gettable(creditor.get(mm+1)).trim(),s+4);
                              }
                            } 
                        }
                    }
                }                
          }          
          //[GLId],[AcctNo],b.[Description],Debet,[Credit],[Rate],[IdrDebet],[IdrCredit],[JobNo],[Note1],[Note2]
          java.util.Vector fix=sgen.getDataQuery(conn,"FIXLEDGERMONTH",cond);
          if(fix.size()==0){
            fix=sgen.getDataQuery(conn,"FIXLEDGER",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          }
          
          java.util.Vector xtampung=new java.util.Vector();
          for(int s=0;s<balance.size();s+=3){
            String acct=gen.gettable(balance.get(s));
            xtampung.addElement(balance.get(s));
            xtampung.addElement(balance.get(s+1));
            String cur="";
            String dd="0",cr="0";
            double xt=gen.getformatdouble(balance.get(s+2));
            double rate=1;
            if(acct.trim().startsWith("12130")||acct.trim().startsWith("12140")||acct.trim().startsWith("12230")||acct.trim().startsWith("22030")){
                    cur="SGD";
            }            
            if(acct.trim().startsWith("12120")||acct.trim().startsWith("12220")||acct.trim().startsWith("22020")){
                    cur="USD";
            }
            for(int ss=0;ss<balanceD.size();ss+=2){
                if(gen.gettable(balance.get(s)).trim().equalsIgnoreCase(gen.gettable(balanceD.get(ss)).trim())){
                    dd=gen.gettable(balanceD.get(ss+1));
                    break;
                }
            }
            for(int ss=0;ss<balanceC.size();ss+=2){
                if(gen.gettable(balance.get(s)).trim().equalsIgnoreCase(gen.gettable(balanceC.get(ss)).trim())){
                    cr=gen.gettable(balanceC.get(ss+1));
                    break;
                }
            }
            if(cur.length()>0){
              for(int ss=0;ss<vkrate.size();ss+=2){
                  if(gen.gettable(vkrate.get(ss)).trim().equalsIgnoreCase(cur.trim())){
                      rate=gen.getformatdouble(vkrate.get(ss+1));
                      xt=rate*xt;
                     // dd=(rate*gen.getformatdouble(dd))+"";
                     // cr=(rate*gen.getformatdouble(cr))+"";
                      break;
                  }
              }
            }
            
            
            
            double bal=gen.getformatdouble(dd)-gen.getformatdouble(cr);
            if(acct.startsWith("1")||acct.startsWith("2")||acct.startsWith("3")){
              bal=xt+gen.getformatdouble(dd)-gen.getformatdouble(cr);
              xtampung.addElement(xt+"");
            }else{
                xtampung.addElement("0");
            }
            
            for(int sm=0;sm<fix.size();sm+=6){
              if(gen.gettable(fix.get(sm)).trim().equalsIgnoreCase(acct.trim())){
                  bal+=gen.getformatdouble(fix.get(sm+4));
                  dd=gen.gettable(fix.get(sm+4));
              }
              if(gen.gettable(fix.get(sm+2)).trim().equalsIgnoreCase(acct.trim())){
                  bal-=gen.getformatdouble(fix.get(sm+4));
                  cr=gen.gettable(fix.get(sm+4));
              }                    
            }
            xtampung.addElement(dd);
            xtampung.addElement(cr);
            xtampung.addElement(bal+"");
          }
          
          balance=xtampung;
          
          for(int m=0;m<fix.size();m+=6){//[trxdate],[SEQ],[KEYT],[AcctCredit],mst_account.[description],[AcctDebit],db.[Description],[curr],[Amount],[my_e],remarks,[REFNO],[TP]
            if(gen.gettable(fix.get(m+5)).trim().length()==0){
                post.addElement("01-"+mth+"-"+y11);
                vpost.addElement("01-"+mth+"-"+y11);
            }else{
                post.addElement(gen.gettable(fix.get(m+5)).trim());
                vpost.addElement(gen.gettable(fix.get(m+5)).trim());
            }
            
            post.addElement("");
            post.addElement("");
            post.addElement(fix.get(m));
            post.addElement(fix.get(m+1));
            post.addElement(fix.get(m+2));
            post.addElement(fix.get(m+3));
            post.addElement("IDR");
            post.addElement(fix.get(m+4));
            post.addElement("");
            post.addElement(gen.gettable(fix.get(m+1)).trim()+"-"+gen.gettable(fix.get(m+3)).trim());
            post.addElement("1");
            post.addElement("FIXGL");
            post.addElement("0");
            post.addElement("FIXGL");
            vpost.addElement("");
            vpost.addElement("");
            vpost.addElement(fix.get(m));
            vpost.addElement(fix.get(m+1));
            vpost.addElement(fix.get(m+2));
            vpost.addElement(fix.get(m+3));
            vpost.addElement("IDR");
            vpost.addElement(fix.get(m+4));
            vpost.addElement("");
            vpost.addElement(gen.gettable(fix.get(m+1)).trim()+"-"+gen.gettable(fix.get(m+3)).trim());
            vpost.addElement("1");
            vpost.addElement("FIXGL");
            vpost.addElement("0");
            vpost.addElement("FIXGL");
          }
          
          ses.setAttribute("GL",vpost);
          int st=fix.size();
          for(int s=st;s<60;s+=6){
            fix.addElement("");
            fix.addElement("");
            fix.addElement("");
            fix.addElement("");
            fix.addElement("0");
            fix.addElement("01-"+mth+"-"+y11);
          }       
          //DIFFERENT RATE   
         String[] judul2=new String[]{"PAID DATE","","","ACCT","DEBET","CREDIT","TRXTYPE","MY E","REFNO","JOBNO","REMARKS"};
         // [JobNo],[Seq],[Vendor],[AcctNo],[Invoice],MYOB,[CurrCost],[rate],[AmtCost],RealRate
         //[TrxDate],a.[Seq],[Bank],[Curr],[Acct],a.[Rate] as ratepay,b.rate as ratecost,credit*(b.rate-a.rate) as untungrate,[Credit] as amtpay,[IDRAmt] as idrpay,[MY_E],[RefNo],[NoteItem1] as jobno,[NotePaid] as debitor              
         cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),crntyear,crntmonth,gen.gettable(ses.getAttribute("TxtErcode")),crntyear,crntmonth};
          
          java.util.Vector data2=sgen.getDataQuery(conn,"DIFFRATE",cond);
          ses.setAttribute("DIFF",data2);
         //DIFF
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <div>
                                                    <label class="control-label">&nbsp;Current Month-Year:<b><%=gen.mon[gen.getInt(crntmonth)-1]%>-<%=crntyear%></b>
                                                      <input type="hidden" name="Y10" value="<%=y10%>">
                                                      <input type="hidden" name="Y11" value="<%=y11%>">
                                                      <input type="hidden" name="act" value="">
                                                    </label>
                                           </div>                                        
                                            <div>
            										<label class="control-label">&nbsp;</label>
                                           </div>    
                                        </div>                                        
											<div class="tabbable">
												<ul class="nav nav-tabs padding-16">
													<li class="active">
														<a data-toggle="tab" href="#edit-post">
															<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
															Posting GL
														</a>
													</li>
													<li>
														<a data-toggle="tab" href="#edit-acct">
															<i class="blue ace-icon fa fa-file-o bigger-125"></i>
														     Account Balance
														</a>
													</li>
													<li>
														<a data-toggle="tab" href="#edit-fix">
															<i class="blue ace-icon fa fa-file-o bigger-125"></i>
														    Fix Ledger
														</a>
													</li>
													<li>
														<a data-toggle="tab" href="#edit-df">
															<i class="blue ace-icon fa fa-file-o bigger-125"></i>
														    Different Rate
														</a>
													</li>
												</ul>
												<div class="tab-content profile-edit-tab-content">
												<div id="edit-post"  class="tab-pane in active">
                              						<form class="form-horizontal" name="post" method="POST" action="Posting.jsp?tp=GLPOST" >
                                                    <div>
                                                        <table id="simple-table2" class="table  table-bordered table-hover">
            												<thead>
            													<tr>
                                                                    <th>DATE</th>
                                                                    <th>DEBET</th>
                                                                    <th>CREDIT</th>
                                                                    <th>Amount</th>
                                                                    <th>REF. NO.</th>                                                                    
                                                                    <th>TRXTYPE</th>
            													</tr>
            												</thead>                
            												<tbody>
                                                                <%                                                                
                                                                for(int i=0;i<post.size();i+=15){%>
                                            						<tr>
                                                                        <td nowrap><%=gen.gettable(post.get(i))%></td>
                                                                        <td nowrap><%=gen.gettable(post.get(i+3))%>-<%=gen.gettable(post.get(i+4)).trim()%></td>
                                                                        <td nowrap><%=gen.gettable(post.get(i+5))%>-<%=gen.gettable(post.get(i+6)).trim()%></td>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(post.get(i+8),0)%></td>
                                                                        <td nowrap><%=gen.gettable(post.get(i+9))%></td>                                                                        
                                                                        <td nowrap><%=gen.gettable(post.get(i+12))%></td>
                                               					    </tr>
                                                                <%}%>
            												</tbody>
            											</table>
                                                    </div>
                                                    <div class="space-4"></div>
    												<div class="clearfix form-actions">
    													<div class="col-md-offset-3 col-md-9">
    														<button class="btn btn-info" type="button" onclick="setsave('3');">
    															<i class="ace-icon fa fa-check bigger-110"></i>
    															Posting
    														</button>
    													</div>
    												</div>
                                                          <input type="hidden" name="act" value="">
                                                          <input type="hidden" name="Y10" value="<%=y10%>">
                                                          <input type="hidden" name="Y11" value="<%=y11%>">
                                                          <input type="hidden" name="x" value="3">
          											</form>
												</div>
                                                
												<div id="edit-acct" class="tab-pane">
                                                    <div>
                                                        <table id="simple-table2" class="table  table-bordered table-hover">
            												<thead>
            													<tr>
                                                                    <th>Account</th>
                                                                    <th>Description</th>
                                                                    <th>Balance <%=gen.mon[gen.getInt(prevm)-1]%>-<%=prevy%></th>
                                                                    <th>Debit <%=gen.mon[gen.getInt(crntmonth)-1]%>-<%=crntyear%></th>
                                                                    <th>Credit <%=gen.mon[gen.getInt(crntmonth)-1]%>-<%=crntyear%></th>
                                                                    <th>Ending Balance</th>
            													</tr>
            												</thead>                
            												<tbody>
                                                                <%
                                                                int h=1;
                                                                for(int i=0;i<balance.size();i+=6){%>
                                            						<tr>
                                                                        <td nowrap><%=gen.gettable(balance.get(i))%></td>
                                                                        <td nowrap><%=gen.gettable(balance.get(i+1))%></td>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(balance.get(i+2),0)%></td>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(balance.get(i+3),0)%></td>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(balance.get(i+4),0)%></td>
                                                                        <td nowrap align=right><%=gen.getNumberFormat(balance.get(i+5),0)%></td>
                                               					    </tr>
                                                                <%h++;}%>
            												</tbody>
            											</table>
                                                    </div>
												</div>
												<div id="edit-fix" class="tab-pane">
                              						<form class="form-horizontal" name="BGA" method="POST" action="Posting.jsp?tp=GLPOST" >
                                                    <div>
                                                        <table id="simple-table" class="table  table-bordered table-hover">
            												<thead>
            													<tr>
                                                                    <th>Debet</th>
                                                                    <th>Credit</th>
                                                                    <th>Amount</th>
                                                                    <th>Date</th>
            													</tr>
            												</thead>                
            												<tbody>
                                                                <%
                                                                int fh=1;
                                                                for(int i=0;i<fix.size();i+=6){
                                                                    if(gen.gettable(fix.get(i+5)).trim().length()==0) fix.setElementAt("01-"+mth+"-"+y11,i+5);
                                                                %>
                                            						<tr>
                                                                        <td nowrap>
                                                    		              <input type="text" name="A<%=fh%>"  size="5" value="<%=gen.gettable(fix.get(i))%>" disabled>
                                                    		              <input type="text" name="B<%=fh%>" size="25" maxlength="60"  value="<%=gen.gettable(fix.get(i+1)).trim()%>" disabled>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('ACCOUNT','A<%=fh%>','B<%=fh%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                        </td>
                                                                        <td nowrap>
                                                                         <input type="text" name="C<%=fh%>"  size="5" value="<%=gen.gettable(fix.get(i+2))%>" disabled>
                                                    		              <input type="text" name="D<%=fh%>" size="25" maxlength="60" value="<%=gen.gettable(fix.get(i+3)).trim()%>" disabled>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('ACCOUNT','C<%=fh%>','D<%=fh%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                        </td>
                                                                        <td nowrap><input type="text" id="E<%=fh%>" size="15" maxlength="20" name="E<%=fh%>"  value="<%=gen.getNumberFormat(fix.get(i+4),0)%>" /></td>
                                                                        <td nowrap><input name="F<%=fh%>" class="input-medium date-picker"  id="F<%=fh%>" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(fix.get(i+5)).trim()%>" placeholder="dd-mm-yyyy" /></td>
                                               					    </tr>
                                                                <%fh++;}%>
            												</tbody>
            											</table>
                                                    </div>
                                                    <div class="space-4"></div>
    												<div class="clearfix form-actions">
    													<div class="col-md-offset-3 col-md-9">
    														<button class="btn btn-info" type="button" onclick="setsave('2');">
    															<i class="ace-icon fa fa-check bigger-110"></i>
    															Save
    														</button>
    													</div>
    												</div>
                                                          <input type="hidden" name="act" value="">
                                                          <input type="hidden" name="Y10" value="<%=y10%>">
                                                          <input type="hidden" name="Y11" value="<%=y11%>">
                                                          <input type="hidden" name="x" value="2">
                                                          <input type="hidden" name="H" value="<%=(fix.size()/6)%>">
                                                          <input type="hidden" name="S1" value="<%=S1%>">
                                                          <input type="hidden" name="S2" value="<%=S2%>">
          											</form>
												</div>
												<div id="edit-df" class="tab-pane">
                                                    <div>
            										<table id="simple-table" class="table  table-bordered table-hover">
            											<thead><tr >													
                                                                    <%for(int s=0;s<judul2.length;s++){
                                                                        if(judul2[s].length()==0)continue;
                                                                    %>         
            														<th nowrap><%=judul2[s]%>&nbsp;</th>
                                                                    <%}%>
                									       </tr></thead>
            											<tbody>
                                                            <% 
                                                            for(int s=0;s<data2.size();s+=judul2.length){%>         
            												<tr>
                                                                   <%for(int ss=0;ss<judul2.length;ss++){
                                                                        if(judul2[ss].length()==0)continue;
                                                                   %>
                                                                        <td nowrap <%if(ss==4||ss==5) out.print("align=right");%>>
                                                                            <%if(ss==4||ss==5){
                                                                                 out.print(gen.getNumberFormat(data2.get(s+ss),2));
                                                                            }else{
                                                                                out.print(gen.gettable(data2.get(s+ss)).trim());
                                                                            }
                                                                        %>
                                                                        </td>
                                                                    <%}%>
            												</tr>
                                                            <% 
                                                            }%>
            											</tbody>
            										</table>
                                                    </div>
												</div>
											</div><!--end tab-->                                                
                                       <!-- </div>-->
                                    </div><!--div id="user-profile-3"-->
                            </div>
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
            function  refresh(){
                      basic.submit();
            }
            function  setsave(Parm){
                if(Parm=="1"){
                     document.acct.act.value="Save";
                      acct.submit();
                }else if(Parm=="2"){
                     <%
                     int hf=1;
                     for(int i=0;i<fix.size();i+=6){%>
                        document.BGA.A<%=hf%>.disabled=false;
                        document.BGA.B<%=hf%>.disabled=false;
                        document.BGA.C<%=hf%>.disabled=false;
                        document.BGA.D<%=hf%>.disabled=false;
                     <%hf++;
                     }%>                
                     document.BGA.act.value="Save";
                     BGA.submit();
                }else if(Parm=="3"){
                     document.post.act.value="Save";
                     post.submit();
                }
            }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
</html>
