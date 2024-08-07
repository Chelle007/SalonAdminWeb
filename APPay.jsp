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
        
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
                conn.setAutoCommit(false);
                msg=sgen.update(conn,"APPAYMENTDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6"))});
               
                //[ErCode] ,[VENDOR] ,curr,[seq],[jobno],[paiddate],[paidamt],[bank],[payno],[refno]
                if(msg.length()==0) {
                    int hi=gen.getInt(request.getParameter("LINE"));
                    for(int m=1;m<=hi;m++){
                        String paid=gen.gettable(request.getParameter("A"+m));
                        if(paid.length()>0){
                            String amt=gen.gettable(request.getParameter("B"+m));
                            String bank=gen.gettable(request.getParameter("C"+m));
                            String payno=gen.gettable(request.getParameter("D"+m));
                            String refno=gen.gettable(request.getParameter("E"+m));
                            String GL=gen.gettable(request.getParameter("F"+m));
                            if(msg.length()==0) msg=sgen.update(conn,"APBANKPAYMENTDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S6")),refno,payno});
                          /*  if(GL.length()>0){
                              if(msg.length()==0) msg=sgen.update(conn,"GLDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GL});
                              if(msg.length()==0) msg=sgen.update(conn,"GLDETAILDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GL});
                            }*/
                            if(msg.length()==0) msg=sgen.update(conn,"APPAYMENTADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6")),paid,amt,bank,payno,refno});
                           // System.out.println("paid="+paid+",amt="+amt+",bank="+bank);
                            //INSERT INTO Trx_BankCash ([Acct],[Credit],[Debit],[Rate],[TrxType],[MY_E],[RefNo],[NoteItem1],[NotePaid],[Remarks] ,ERCODE,BANK,TrxDate,SEQ,curr
                            String SEQ="1";
                            java.util.Vector vbank=sgen.getDataQuery(conn,"BANKMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),bank});
                            if(vbank.size()>0){
                                SEQ=(gen.getInt(vbank.get(0))+1)+"";
                            }
                            String[] xc=new String[]{Gen.gettable(request.getParameter("S9")),amt,"0","1","COST",payno,refno,Gen.gettable(request.getParameter("S6")),Gen.gettable(request.getParameter("S2")),payno,gen.gettable(ses.getAttribute("TxtErcode")),bank,paid,SEQ,gen.gettable(request.getParameter("S4")),"0",Gen.gettable(request.getParameter("S1"))};
                            String rate="1";
                            if(!gen.gettable(request.getParameter("S4")).equalsIgnoreCase("IDR")){
                                  java.util.Vector vkrate=sgen.getDataQuery(conn,"RATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S4")),paid});
                                  if(vkrate.size()>0){
                                      rate=gen.gettable(vkrate.get(0));
                                  }                       
                            }
                            xc[3]=rate;
                            if(msg.length()==0) msg=sgen.update(conn,"TRX_BANKADD",xc);
                            if(msg.length()==0) msg=sgen.update(conn,"TRX_BANKCOSTUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),bank,paid,SEQ});
                            //[ErCode] ,[BillTo] ,curr,[seq],[jobno],[ErCode] ,[BillTo] ,curr,[seq],[jobno]
                            if(msg.length()==0) msg=sgen.update(conn,"APPAYUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6"))});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"APPAYMENTADD",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("S1"))+"|"+Gen.gettable(request.getParameter("S4"))+"|"+Gen.gettable(request.getParameter("S5"))+"|"+Gen.gettable(request.getParameter("S6"))+"|"+paid+"|"+payno+"|"+refno+"|"});
                                            //[ErCode] ,[GLId],[TrxDate],curr,[Remarks]
                           /* SEQ="1";
                            java.util.Vector pp=gen.getElement('-',paid+"-");
                            
                            java.util.Vector crnt=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                            String yr=gen.gettable(pp.get(2)).substring(2);
                            String mth=gen.gettable(pp.get(1));
                            if(crnt.size()>0){
                                yr=gen.gettable(crnt.get(1)).substring(2);
                                mth=gen.gettable(crnt.get(0));
                            }
                            if(mth.length()==1)mth="0"+mth;
                            java.util.Vector gl=sgen.getDataQuery(conn,"GLMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),yr+mth+"%"});
                            if(gl.size()>0){
                                String x=gen.gettable(gl.get(0)).trim().substring(4);
                                SEQ=(gen.getInt(x)+1)+"";
                            }
                            String GLID=SEQ;
                            for(int mx=SEQ.length();mx<5;mx++){
                                GLID="0"+GLID;
                            }
                            GLID=yr+mth+GLID;
                            xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,paid,gen.gettable(request.getParameter("S4")),"Account Payable"};
                            if(msg.length()==0) msg=sgen.update(conn,"GLADD",xc);
                            if(msg.length()==0) msg=sgen.update(conn,"APPAYMENTUPDATE",new String[]{GLID,gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6")),paid,payno});
                            
                            java.util.Vector acctb=sgen.getDataQuery(conn,"ACCTBANK",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),bank});
                            if(acctb.size()>0){
                                //[ErCode] ,[GLId],[AcctNo],Debet,Credit,Rate,IDrDebet,IDrCredit,jobno,[note1],note2
                                double idramt=gen.getReleaseNumberFormat(amt)*gen.getformatdouble(rate);
                                xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,Gen.gettable(request.getParameter("S9")),amt,"0",rate,idramt+"","0",Gen.gettable(request.getParameter("S6")),"Costs",""};
                                if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);
                                xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),GLID,Gen.gettable(acctb.get(0)).trim(),"0",amt,rate,"0",idramt+"",Gen.gettable(request.getParameter("S6")),Gen.gettable(acctb.get(1)).trim(),""};
                                if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);
                            }
                            
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"APGLADD",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+GLID+"|"});
                            */if(msg.length()>0) break;
                        }
                    }
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
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){
                conn.setAutoCommit(false);
                /*if(Gen.gettable(request.getParameter("P4")).length()>0){
                    if(msg.length()==0) msg=sgen.update(conn,"GLDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("P4"))});
                    if(msg.length()==0) msg=sgen.update(conn,"GLDETAILDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("P4"))});
                }*/
                msg=sgen.update(conn,"APPAYMENTDDDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6")),Gen.gettable(request.getParameter("P1")),Gen.gettable(request.getParameter("P2")),Gen.gettable(request.getParameter("P3"))});
                if(msg.length()==0) msg=sgen.update(conn,"APBANKPAYMENTDDDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S6")),Gen.gettable(request.getParameter("P1")),Gen.gettable(request.getParameter("P2")),Gen.gettable(request.getParameter("P3"))});
                if(msg.length()==0) msg=sgen.update(conn,"APPAYUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S5")),Gen.gettable(request.getParameter("S6"))});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"APPAYMENTDDDELETE",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("S1"))+"|"+Gen.gettable(request.getParameter("S4"))+"|"+Gen.gettable(request.getParameter("S5"))+"|"+Gen.gettable(request.getParameter("S6"))+"|"+Gen.gettable(request.getParameter("P1"))+"|"+Gen.gettable(request.getParameter("P2"))+"|"+Gen.gettable(request.getParameter("P3"))+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Save Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Save Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }

         String[] judul=new String[]{"PAID DATE","PAID AMOUNT","BANK","PAY NO.","REF. NO.",""};
         
          String title="AP Payment Detail";       
          String[] cond=new String[0];
        java.util.Vector bank=sgen.getDataQuery(conn,"BANKCODEBYCURR",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S4"))});
            String p=Gen.gettable(request.getParameter("P"));
            if(p.length()==0) p=gen.getToday("dd-MM-yyyy");
            String y11=gen.gettable(request.getParameter("Y11"));
            String y10=gen.gettable(request.getParameter("Y10"));
            double balx=gen.getformatdouble(request.getParameter("S7"));
            java.util.Vector data=sgen.getDataQuery(conn,tp,new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6"))});
            for(int m=0;m<data.size();m+=6){
                balx-=gen.getformatdouble(data.get(m+1));
            }
            data.addElement("");
            data.addElement("");
            data.addElement("");
            data.addElement("");
            data.addElement("");
            data.addElement("");
            if(msg.startsWith("(Save Data Failed")){
                java.util.Vector tmp1=new java.util.Vector();
                int hx=gen.getInt(request.getParameter("LINE"));
                for(int m=1;m<=hx;m++){
                      tmp1.addElement(request.getParameter("A"+m));
                      tmp1.addElement(request.getParameter("B"+m));
                      tmp1.addElement(request.getParameter("C"+m));
                      tmp1.addElement(request.getParameter("D"+m));
                      tmp1.addElement(request.getParameter("E"+m));
                      tmp1.addElement(request.getParameter("F"+m));
                }
                data=tmp1;                    
            }            
        //System.out.println(tpx+","+f3+","+gen.gettable(request.getParameter("Y14")));
        String view="";
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
				<form class="form-horizontal" name="BGA" method="POST" action="APPay.jsp?tp=<%=tp%>" >
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">&nbsp;&nbsp;&nbsp;Curr:<b><%=gen.gettable(request.getParameter("S4"))%></b></label>                                                                
										    <label class="control-label">&nbsp;&nbsp;&nbsp;Vendor:<b><%=Gen.gettable(request.getParameter("S1"))%>&nbsp;(<%=Gen.gettable(request.getParameter("S2"))%>)</b></label>
                                            <label class="control-label">&nbsp;&nbsp;Job No.:<b><%=Gen.gettable(request.getParameter("S6"))%></b></label>
                                            <label class="control-label">&nbsp;&nbsp;Job Amount:<b><%=Gen.getNumberFormat(request.getParameter("S7"),2)%></b></label>
                                            <label class="control-label">&nbsp;&nbsp;Balance.:<b><%=Gen.getNumberFormat(""+balx,2)%></b>                                            
                                            <input type="hidden" name="S1" value="<%=Gen.gettable(request.getParameter("S1"))%>" >
                                            <input type="hidden" name="S2" value="<%=Gen.gettable(request.getParameter("S2"))%>" >
                                            <input type="hidden" name="S3" value="<%=Gen.gettable(request.getParameter("S3"))%>" >
                                            <input type="hidden" name="S4" value="<%=gen.gettable(request.getParameter("S4"))%>" >
                                            <input type="hidden" name="S5" value="<%=gen.gettable(request.getParameter("S5"))%>" >
                                            <input type="hidden" name="S6" value="<%=gen.gettable(request.getParameter("S6"))%>" >
                                            <input type="hidden" name="S7" value="<%=gen.gettable(request.getParameter("S7"))%>" >
                                            <input type="hidden" name="S8" value="<%=gen.gettable(request.getParameter("S8"))%>" >
                                            <input type="hidden" name="S9" value="<%=gen.gettable(request.getParameter("S9"))%>" >
                                            <input type="hidden" name="act" value="" >
                                            <input type="hidden" name="P1" value="" >
                                            <input type="hidden" name="P2" value="" >
                                            <input type="hidden" name="P3" value="" >
                                            <input type="hidden" name="P4" value="" >
                                            <input type="hidden" name="LINE" value="<%=(data.size()/judul.length)%>" >
                                            <input type="hidden" name="Y14" value="<%=gen.gettable(request.getParameter("Y14"))%>" ><!--untuk status outstanding/validate-->
                                            </label>
                                    </div>
                                 </div>
                               </div>
                             </div>
                          </div>

						<div class="row">
							<div id="user-profile-3"  class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>													
                                                        <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%}%>
                                                        <th>DELETE&nbsp;</th>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                      <td>                                                       
                                                       <input class="input-medium date-picker" name="A<%=hic%>"  id="A<%=hic%>" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(data.get(s))%>" placeholder="dd-mm-yyyy"/><i class="ace-icon fa fa-calendar"></i></td>                                                            
                                                      <td><input type="text" name="B<%=hic%>" size="10" maxlength="10" value="<%=gen.getNumberFormat(data.get(s+1),2)%>" ></td>
                                                      <TD><select name="C<%=hic%>">
                                                          <option></option>
                                                          <%for(int m=0;m<bank.size();m+=2){%>
                                                              <option value="<%=gen.gettable(bank.get(m))%>" <%if(gen.gettable(data.get(s+2)).trim().equalsIgnoreCase(gen.gettable(bank.get(m)).trim())) out.print("selected");%>><%=gen.gettable(bank.get(m+1)).trim()%></option>            
                                                          <%}%>
                                                      </select>
                                                      </TD>
                                                      <td><input type="text" name="D<%=hic%>" size="15" maxlength="20" value="<%=gen.gettable(data.get(s+3)).trim()%>" ></td>
                                                      <td><input type="text" name="E<%=hic%>" size="15" maxlength="20" value="<%=gen.gettable(data.get(s+4)).trim()%>" >
                                                      <input type="hidden" name="F<%=hic%>"  value="<%=gen.gettable(data.get(s+5)).trim()%>" ></td>
                                                    <td nowrap>
                                                    <%if(gen.gettable(data.get(s)).trim().length()>0 && gen.gettable(data.get(s+5)).trim().length()==0){%>
                                                    <button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s))%>','<%=gen.gettable(data.get(s+3)).trim()%>','<%=gen.gettable(data.get(s+4)).trim()%>','<%=gen.gettable(data.get(s+5)).trim()%>')">
          												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                                    <%}%>
                                                    </td>
												</tr>
                                                <%  hic++;
                                                }%>
											</tbody>
										</table>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
                         <div class="row" align=center>
                      		<button class="btn btn-info" type="button" onclick="setsave();">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                      		<button class="btn btn-info" type="button" onclick="onreturn();">
                      			<i class="ace-icon fa fa-return bigger-110"></i>
                      			Back
                      		</button>
                        </div>

					</div><!-- /.page-content -->
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
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
		<script src="assets/js/buttons.flash.min.js"></script>
        <script src="assets/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/buttons.html5.min.js"></script>
		<script src="assets/js/buttons.print.min.js"></script>
		<script src="assets/js/buttons.colVis.min.js"></script>
		<script src="assets/js/dataTables.select.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
            function  setsave(){
                <%
                hic=1;
                for(int s=0;s<data.size();s+=judul.length){%>
                      if(document.BGA.A<%=hic%>.value=="" && document.BGA.B<%=hic%>.value!=""){
                            alert("Paid Date must be filled!");
                            return;
                      }
                      if(document.BGA.A<%=hic%>.value!="" && document.BGA.C<%=hic%>.value==""){
                            alert("Bank must be filled!");
                            return;
                      }
                      if(document.BGA.A<%=hic%>.value!="" && (document.BGA.D<%=hic%>.value==""&&document.BGA.E<%=hic%>.value=="")){
                            alert("Pay No./Ref No. must be filled!");
                            return;
                      }
                <%
                    hic++;
                }%>
                 document.BGA.act.value="Save";
                  BGA.submit();
            }
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
     function onreturn(){
        location.href="APDetail.jsp?tp=APDETAIL&canedit=true&Y10=<%=y10%>&Y11=<%=y11%>&Y14=<%=Gen.gettable(request.getParameter("Y14"))%>&S1=<%=Gen.gettable(request.getParameter("S1"))%>&S2=<%=Gen.gettable(request.getParameter("S2"))%>&S3=<%=Gen.gettable(request.getParameter("S3"))%>&S4=<%=Gen.gettable(request.getParameter("S4"))%>";
    }
            
    function ondel(Parm,Parm2,Parm3,Parm4){
        if(confirm("Delete Selected Record?","Delete")){
           document.BGA.act.value="DEL";
           document.BGA.P1.value=Parm;
           document.BGA.P2.value=Parm2;
           document.BGA.P3.value=Parm3;
           document.BGA.P4.value=Parm4;
            BGA.submit();
        }
    }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
</html>
