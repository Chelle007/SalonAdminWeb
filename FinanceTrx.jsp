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
          java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         String crntyear="",crntmonth="",ty="",tm="";
         if(userdef.size()>0){
            crntmonth=gen.gettable(userdef.get(0));
            crntyear=gen.gettable(userdef.get(1));

         }
          String s1=gen.gettable(request.getParameter("S1"));
          if(request.getParameter("S1")==null){
                s1="COST";
          }
          String tpx="DIFF"+s1;
         
         //x=1 save move acct tax,x=2 diff rate,3=contra
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
            if(Gen.gettable(request.getParameter("x")).equalsIgnoreCase("1")){
                if(userdef.size()>0){
                  if(crntmonth.length()==1)crntmonth="0"+crntmonth;
                }
                String prevy=crntyear,prevm=(gen.getInt(crntmonth)-1)+"";
                 
                if(prevm.equalsIgnoreCase("0")){
                  prevy=(gen.getInt(prevy)-1)+"";
                  prevm="12";
                }
                String trx=Gen.gettable(request.getParameter("Y13"));
                java.util.Vector sd=gen.getElement('-',trx+"-");
                if(sd.size()>0){
                      tm=gen.gettable(sd.get(1));
                      ty=gen.gettable(sd.get(2));
                }
                if(gen.getInt(ty)==gen.getInt(crntyear) && gen.getInt(tm)<gen.getInt(crntmonth)){
                      conn.setAutoCommit(false);            
                    java.util.Vector gl=sgen.getDataQuery(conn,"GLMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),ty.substring(2)+tm+"%"});
                    int SEQ=1;
                    if(gl.size()>0){
                        String x=gen.gettable(gl.get(0)).trim().substring(4);
                        SEQ=(gen.getInt(x)+1);
                    }
                    String xGLID=SEQ+"";
                    String glid=SEQ+"";
                    for(int m=xGLID.length();m<5;m++){
                        glid="0"+glid;
                    }
                    glid=ty.substring(2)+tm+glid;
                    
                    java.util.Vector dta=(java.util.Vector)ses.getAttribute("OLDGL");//lepasin
                    if(msg.length()==0) msg=sgen.update(conn,"GLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,gen.gettable(request.getParameter("Y13")),"IDR","","TAXCLAIM",""});
                    double tot=0;
                    for(int sm=0;sm<dta.size();sm+=6){
                        String acct=gen.gettable(dta.get(sm));
                        String idrd=gen.gettable(dta.get(sm+2));
                        String idrc=gen.gettable(dta.get(sm+3));
                        tot+=gen.getformatdouble(dta.get(sm+3));
                        String job=gen.gettable(dta.get(sm+4));
                        String rem=gen.gettable(dta.get(sm+5));
                        String[] xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,acct,idrd,idrc,"1",idrd,idrc,job,rem,""};
                        if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);                
                    }
                    if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"MOVEACCTADD",glid+"|"});
                    if(msg.length()==0){
                        int startm=gen.getInt(tm);
                        int endm=gen.getInt(prevm);
                        if(startm>endm){
                            endm+=12;
                        }
                        String loopy=ty;
                        String acct1="23330";
                        String acct2="64302";
                        for(int smm=startm;smm<=endm;smm++){
                          int loopm=smm;
                          if(smm>12){
                            loopy=""+(gen.getInt(loopy)+1);
                            loopm=1;
                          }
                          java.util.Vector bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct1});
                          if(bal.size()>0){
                              double amt=gen.getformatdouble(bal.get(0))-tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct1,loopy,loopm+""});
                          }else{
                              double amt=-1*tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct1,loopy,loopm+"",amt+""});
                          }                
                          bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct2});
                          if(bal.size()>0){
                              double amt=gen.getformatdouble(bal.get(0))+tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct2,loopy,loopm+""});
                          }else{
                              double amt=tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct2,loopy,loopm+"",amt+""});
                          }                
                        }
                        
                    }
    
                    if(msg.length()>0){
                        conn.rollback();
                        msg="(Data Save Failed!!"+msg+")";
                    }else{
                        conn.commit();
                        msg="(Saved Successfully)";
                    }     
                    conn.setAutoCommit(true);   
                }else{
                    msg="Invalid Ledger Date!The Date is not posting.";                    
                }
              }else if(Gen.gettable(request.getParameter("x")).equalsIgnoreCase("3")){             
                conn.setAutoCommit(false);
                int m=1;
                 String mseq="1";
                java.util.Vector mx=sgen.getDataQuery(conn,"UNPOSTGLSEQ",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                if(mx.size()>0) mseq=""+(gen.getInt(mx.get(0))+1);
                for(int sm=0;sm<gen.getInt(request.getParameter("H"));sm++){
                    double rate=0;
                    if(gen.gettable(request.getParameter("R"+m)).equalsIgnoreCase("ON")){
                        if(msg.length()==0) msg=sgen.update(conn,"CONTRADELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("F"+m)),gen.gettable(request.getParameter("C"+m))});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"CONTRADELETE",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("F"+m))+"|"+gen.gettable(request.getParameter("C"+m))+"|"});
                    }else if(request.getParameter("C"+m).length()>0){//tanggal isi
                        rate=gen.getReleaseNumberFormat(request.getParameter("E"+m));
                        String trx=gen.gettable(request.getParameter("C"+m));
                        String seq=gen.gettable(request.getParameter("F"+m));
                        String dac=gen.gettable(request.getParameter("A"+m));
                        String cac=gen.gettable(request.getParameter("B"+m));
                        String amt=gen.gettable(request.getParameter("G"+m));
                        String note=gen.gettable(request.getParameter("D"+m));
                        if(seq.length()==0){//insert
                             seq=mseq;
                            if(msg.length()==0) msg=sgen.update(conn,"CONTRAADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),seq,trx,dac,cac,"",rate+"",amt,"0",note,""});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"CONTRAADD",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+seq+"|"+trx+"|"+dac+"|"+cac+"|"});
                            mseq=""+(gen.getInt(mseq)+1);
                        }else{
                            
                            if(msg.length()==0) msg=sgen.update(conn,"CONTRAEDIT",new String[]{dac,cac,"",rate+"",amt,"0",note,"",gen.gettable(ses.getAttribute("TxtErcode")),seq,trx});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"CONTRAEDIT",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+seq+"|"+trx+"|"+dac+"|"+cac+"|"});
                        }
                        //System.out.println("trx="+trx+","+dac+","+cac+",seq="+seq);
                        //[ErCode] ,[Seq],[TrxDate],[DAcctNo],[CAcctNo],[curr] ,[Rate],[Amt],[IdrAmt],[Note],[RefNo]
                        if(msg.length()==0) msg=sgen.update(conn,"CONTRAUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),dac,cac,gen.gettable(ses.getAttribute("TxtErcode")),seq,trx});                      
                    }
                    m++;
                }
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Save Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Save Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }
          }
          //[AcctNo],[description],[IDRAmt],jobno,remarks  
          //movement acct tax
         String[] judul1=new String[]{"ACCOUNT","DESCRIPTION","DEBIT","CREDIT","JOBNO","REMARK"};
          
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("Y12"))};
          java.util.Vector data1=sgen.getDataQuery(conn,"MOVEACCT",cond);
          java.util.Vector tamp=new java.util.Vector();
          for(int s=0;s<data1.size();s+=6){
                for(int ss=0;ss<6;ss++) tamp.addElement(data1.get(s+ss));
                tamp.addElement("64302");
                tamp.addElement("TAX 23");
                tamp.addElement(data1.get(s+3));
                tamp.addElement("0");
                tamp.addElement(data1.get(s+4));
                tamp.addElement(data1.get(s+5));                                                                                              
          }
          ses.setAttribute("OLDGL",tamp);
        

         String y10=gen.gettable(request.getParameter("M0"));
         String y11=gen.gettable(request.getParameter("M1"));
         if(request.getParameter("M0")==null){ 
            y10=gen.gettable(userdef.get(0));
            y11=gen.gettable(userdef.get(1));
         }

          java.util.Vector fix=sgen.getDataQuery(conn,"CONTRA",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
          java.util.Vector acct=sgen.getDataQuery(conn,"ACCTCONTRA",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          
            fix.addElement("");
            fix.addElement("");
            fix.addElement("");
            fix.addElement("");            
            fix.addElement("");            
            fix.addElement("1");
            fix.addElement("0");
            fix.addElement("");
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

          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>Moving Ledger <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
									<div id="user-profile-3" class="user-profile row">
                                        <div>
											<div class="tabbable">
												<ul class="nav nav-tabs padding-16">
													<li <%if(gen.gettable(request.getParameter("x")).equalsIgnoreCase("1")||gen.gettable(request.getParameter("x")).length()==0){ %>class="active" <%}%>>
														<a data-toggle="tab" href="#edit-post">
															<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
															Moving Tax
														</a>
													</li>
													<li <%if(gen.gettable(request.getParameter("x")).equalsIgnoreCase("3")){%>class="active"<%}%>>
														<a data-toggle="tab" href="#edit-fix">
															<i class="blue ace-icon fa fa-file-o bigger-125"></i>
														    Contra Entry
														</a>
													</li>
												</ul>
												<div class="tab-content profile-edit-tab-content">
												<div id="edit-post"  class="tab-pane<%if(gen.gettable(request.getParameter("x")).equalsIgnoreCase("1")||gen.gettable(request.getParameter("x")).length()==0){ %> in active<%}%>">
                              						<form class="form-horizontal" name="MX" method="POST" action="FinanceTrx.jsp?tp=FINTRX&x=1" >
                                                    <div>                                  						
                                                    Job Date From:<input class="input-medium date-picker" name="Y11"  id="Y11" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y11"))%>" placeholder="dd-mm-yyyy"  onchange="refresh1();"/>
													&nbsp;&nbsp;Date To:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh1();"/>
                                                    &nbsp;&nbsp;Ledger Date:<input class="input-medium date-picker" name="Y13"  id="Y13" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  />
                                                    </div>
                                                    <div>
                										<table id="simple-table" class="table  table-bordered table-hover">
                											<thead>
                												<tr>													                                                                    
                                                                        <%for(int s=0;s<judul1.length;s++){%>         
                														<td align=center><b><%=judul1[s]%>&nbsp;</td>
                                                                        <%}%>
                    											</tr>
                											</thead>
                
                											<tbody>                                                                   
                                                               <%  int hic=1;
                                                            for(int s=0;s<tamp.size();s+=judul1.length){%>         
                												<tr>
                                                                   <%for(int ss=0;ss<judul1.length;ss++){%>
                                                                        <td nowrap><%=gen.gettable(tamp.get(s+ss)).trim()%></td>
                                                                    <%}%>
                												</tr>
                                                        <%}//%>
            											</tbody>
            										</table>
                                                    </div>
                                                    <div class="space-4"></div>
    												<div class="clearfix form-actions">
    													<div class="col-md-offset-3 col-md-9">
    														<button class="btn btn-info" type="button" onclick="setsave('1');">
    															<i class="ace-icon fa fa-check bigger-110"></i>
    															Save
    														</button>
    													</div>
    												</div>
                                                      <input type="hidden" name="act" value="">
          											</form>
												</div>
												<div id="edit-fix" class="tab-pane <%if(gen.gettable(request.getParameter("x")).equalsIgnoreCase("3")){%> in active<%}%>">
                              						<form class="form-horizontal" name="BGA" method="POST" action="FinanceTrx.jsp?tp=FINTRX&x=3" >
                                                    <div class="col-sm-offset-1 col-sm-10">
                                                            <label class="control-label">Month:                                             
                                                            <select name="M0"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(y10.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										                  <label class="control-label">&nbsp;Year:<input type="text" name="M1" size="4" maxlength="4" value="<%=y11%>"> </label>
                                                         </div>
                                                    <div>
                                                        <table id="simple-table" class="table  table-bordered table-hover">
            												<thead>
            													<tr>
                                                                    <th>Seq</th>
                                                                    <th>Date</th>
                                                                    <th>Debet</th>                                                                    
                                                                    <th>Credit</th>
                                                                    <th>Memo</th>
                                                                    <th>Rate</th>
                                                                    <th>Amount</th>
                                                                    <th>Remove</th>
                            									</tr>
            												</thead>                
            												<tbody>
                                                                <%
                                                                int fh=1;
                                                                for(int i=0;i<fix.size();i+=8){           
                                                                    String ACT1=gen.gettable(request.getParameter("AA"+fh));        
                                                                    String ACT2=gen.gettable(request.getParameter("BB"+fh));      
                                                                    if(ACT1.length()==0 && gen.gettable(fix.get(i+2)).trim().length()>0){
                                                                        for(int s=0;s<acct.size();s+=2){
                                                                            if(gen.gettable(acct.get(s)).trim().equalsIgnoreCase(gen.gettable(fix.get(i+2)).trim())){
                                                                                ACT1=gen.gettable(acct.get(s+1)).trim();
                                                                                break;
                                                                            }
                                                                        }
                                                                    }                                                           
                                                                    if(ACT2.length()==0 && gen.gettable(fix.get(i+3)).trim().length()>0){
                                                                        for(int s=0;s<acct.size();s+=2){
                                                                            if(gen.gettable(acct.get(s)).trim().equalsIgnoreCase(gen.gettable(fix.get(i+3)).trim())){
                                                                                ACT2=gen.gettable(acct.get(s+1)).trim();
                                                                                break;
                                                                            }
                                                                        }
                                                                    }                                                           
                                                                %>
                                            						<tr>
                                                                         <td nowrap><input type="hidden" name="F<%=fh%>" id="F<%=fh%>" type="text" value="<%=gen.gettable(fix.get(i)).trim()%>" /><%=gen.gettable(fix.get(i)).trim()%></td>
                                                                         <td nowrap><input name="C<%=fh%>" class="input-medium date-picker"  id="C<%=fh%>" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(fix.get(i+1)).trim()%>" placeholder="dd-mm-yyyy" /></td>
                                                                        <td nowrap>
                                                    		              <input type="text" name="A<%=fh%>"  size="4" value="<%=gen.gettable(fix.get(i+2))%>" disabled>
                                                    		              <input type="text" name="AA<%=fh%>" size="10" maxlength="60"  value="<%=ACT1%>" disabled>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('ACCOUNT','A<%=fh%>','AA<%=fh%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                        </td>
                                                                        <td nowrap>
                                                                         <input type="text" name="B<%=fh%>"  size="4" value="<%=gen.gettable(fix.get(i+3))%>" disabled>
                                                    		              <input type="text" name="BB<%=fh%>" size="10" maxlength="60" value="<%=ACT2%>" disabled>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('ACCOUNT','B<%=fh%>','BB<%=fh%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                        </td>
                                                                        <td nowrap><input type="text" id="D<%=fh%>" size="10" maxlength="60" name="D<%=fh%>"  value="<%=gen.gettable(fix.get(i+7))%>" /></td>
                                                                        <td nowrap><input type="text" id="E<%=fh%>" size="5" maxlength="6" name="E<%=fh%>"  value="<%=gen.getNumberFormat(fix.get(i+5),0)%>" /></td>
                                                                        <td nowrap><input type="text" id="G<%=fh%>" size="10" maxlength="20" name="G<%=fh%>"  value="<%=gen.getNumberFormat(fix.get(i+6),0)%>" /></td>
                                               					         <td nowrap> <input type="checkbox" name="R<%=fh%>" value="ON" ></td>
                                                                    </tr>
                                                                <%fh++;}%>
            												</tbody>
            											</table>
                                                    </div>
                                                    <div class="space-4"></div>
    												<div class="clearfix form-actions">
    													<div class="col-md-offset-3 col-md-9">
    														<button class="btn btn-info" type="button" onclick="setsave('3');">
    															<i class="ace-icon fa fa-check bigger-110"></i>
    															Save
    														</button>
    													</div>
    												</div>
                                                          <input type="hidden" name="act" value="">                                                        
                                                          <input type="hidden" name="H" value="<%=(fix.size()/8)%>">
          											</form>
												</div>
											</div><!--end tab-->                                                
                                        </div>
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
            function  refresh1(){
                      MX.submit();
            }
            function  refresh2(){
                      DF.submit();
            }
            function  setsave(Parm){
                if(Parm=='3'){
                    <%int h=1; 
                    for(int i=0;i<fix.size();i+=8){ %>
                        document.BGA.A<%=h%>.disabled=false;
                        document.BGA.B<%=h%>.disabled=false;
                    <%h++;}%>
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }else if(Parm=='2'){
                     document.DF.act.value="Save";
                      DF.submit();
                  }else if(Parm=='1'){
                     document.MX.act.value="Save";
                      MX.submit();
                 }
            }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
</html>
