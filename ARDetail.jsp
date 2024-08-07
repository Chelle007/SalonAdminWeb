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
                java.util.Vector dold=(java.util.Vector)ses.getAttribute("PAY");
                java.util.Vector CT=sgen.getDataQuery(conn,"CONTRAACCT",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                String contra="";
                if(CT.size()>0) contra=gen.gettable(CT.get(0));
                int hh=1;
                for(int s=0;s<dold.size();s+=8){
                      if(request.getParameter("A"+hh)==null&&request.getParameter("B"+hh)==null) break;
                      double bal=gen.getformatdouble(dold.get(s+4))-gen.getformatdouble(dold.get(s+6));
                      if(!gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid") && bal!=0){                                                            
                      }else if(gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid") && bal==0){
                      }else{
                          continue;
                      }
                      boolean can=false;
                      if(gen.gettable(request.getParameter("A"+hh)).equalsIgnoreCase("ON")){
                        can=true;
                        bal=Math.round(0.98*bal);
                      }else{
                        if(gen.gettable(request.getParameter("B"+hh)).equalsIgnoreCase("ON")){
                            can=true;
                        }
                      }
                      String S5=gen.gettable(dold.get(s));
                      String S6=gen.gettable(dold.get(s+1));
                      String S7=gen.gettable(request.getParameter("S7"));
                      String S8=bal+"";
                      String S9=gen.gettable(dold.get(s+2));
                      String P2=Gen.gettable(request.getParameter("P2"));
                      if(P2.trim().length()==0)P2=gen.gettable(dold.get(s+5)).trim();
                      if(can){
                        if(S7.equalsIgnoreCase("Contra")){
                            //INSERT INTO [dbo].[Trx_ARPayment] ([ErCode] ,[BillTo] ,curr,[seq],[jobno],[paiddate],[paidamt],[ACCTNO],[payno],[refno]) VALUES (? ,?,?,?,?,?,?,?,?,?)
                            //if(msg.length()==0) msg=sgen.update(conn,"ARPAYMENTADDCONTRA",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6,Gen.gettable(request.getParameter("P")),S8,contra,Gen.gettable(request.getParameter("P1")),P2});
                           // if(msg.length()==0) msg=sgen.update(conn,"CONTRADETAILADD",xc);
                          //  if(msg.length()==0) msg=sgen.update(conn,"ARPAYUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6,gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6});
                           // if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"ARPAYMENTADDH",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("S1"))+"|"+Gen.gettable(request.getParameter("S4"))+"|"+S5+"|"+S6+"|"+Gen.gettable(request.getParameter("P"))+"|"});
                        }else{
                            //INSERT INTO [dbo].[Trx_ARPayment] ([ErCode] ,[BillTo] ,curr,[seq],[jobno],[paiddate],[paidamt],[bank],[payno],[refno]) VALUES (? ,?,?,?,?,?,?,?,?,?)
                            if(msg.length()==0) msg=sgen.update(conn,"ARPAYMENTADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6,Gen.gettable(request.getParameter("P")),S8,S7,Gen.gettable(request.getParameter("P1")),P2});
                            //INSERT INTO Trx_BankCash ([Acct],[Credit],[Debit],[Rate],[TrxType],[MY_E],[RefNo],[NoteItem1],[NotePaid],[Remarks] ,ERCODE,BANK,TrxDate,SEQ,curr
                            String SEQ="1";
                            java.util.Vector vbank=sgen.getDataQuery(conn,"BANKMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S7});
                            if(vbank.size()>0){
                                SEQ=(gen.getInt(vbank.get(0))+1)+"";
                            }
                            String[] xc=new String[]{S9,"0",S8,"1","SALES",Gen.gettable(request.getParameter("P1")),P2,S6,Gen.gettable(request.getParameter("S2")),Gen.gettable(request.getParameter("P1")),gen.gettable(ses.getAttribute("TxtErcode")),S7,Gen.gettable(request.getParameter("P")),SEQ,gen.gettable(request.getParameter("S4")),"0",Gen.gettable(request.getParameter("S1"))};
                            String rate="1";
                            if(!gen.gettable(request.getParameter("S4")).equalsIgnoreCase("IDR")){
                                  java.util.Vector vkrate=sgen.getDataQuery(conn,"RATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("P"))});
                                  if(vkrate.size()>0){
                                      rate=gen.gettable(vkrate.get(0));
                                  }                       
                            }
                            xc[3]=rate;
                            if(msg.length()==0) msg=sgen.update(conn,"TRX_BANKADD",xc);
                            if(msg.length()==0) msg=sgen.update(conn,"TRX_BANKUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),S7,Gen.gettable(request.getParameter("P")),SEQ});
                            //[ErCode] ,[BillTo] ,curr,[seq],[jobno],[ErCode] ,[BillTo] ,curr,[seq],[jobno]
                            //UPDATE TRX_JOBSALES SET PAIDAMT=(SELECT SUM(PAIDAMT) FROM Trx_ARPayment WHERE ERCODE=? AND billto=? and curr=? and seq=? and jobno=?) WHERE ERCODE=? AND billto=? and curr=? and seq=? and jobno=?
                            if(msg.length()==0) msg=sgen.update(conn,"ARPAYUPDATE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6,gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1")),Gen.gettable(request.getParameter("S4")),S5,S6});
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"ARPAYMENTADDH",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("S1"))+"|"+Gen.gettable(request.getParameter("S4"))+"|"+S5+"|"+S6+"|"+Gen.gettable(request.getParameter("P"))+"|"});
                            if(msg.length()>0) break; 
                        }
                    }
                      hh++;
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

         String[] judul=new String[]{"SEQ","JOBNO","ACCOUNT","RATE","AMOUNT","MYOB","PAID AMT",""};
         
          String title="Account Receivable";       
          String[] cond=new String[0];
          
          java.util.Vector balance=sgen.getDataQuery(conn,"ARBALANCE"+gen.gettable(request.getParameter("Y14")),new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S4"))});
          String bb="0";
          if(balance.size()>0){
            bb=gen.gettable(balance.get(0));
          }
        java.util.Vector bank=sgen.getDataQuery(conn,"BANKCODEBYCURR",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S4"))});
            String p=Gen.gettable(request.getParameter("P"));
            if(p.length()==0) p=gen.getToday("dd-MM-yyyy");
            String y11=gen.gettable(request.getParameter("Y11"));
            String y10=gen.gettable(request.getParameter("Y10"));
            String[] CDX=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S4"))};
            String TPX=tp+gen.gettable(request.getParameter("Y14"));
           String dfp=Gen.gettable(request.getParameter("P3"));
           if(dfp.length()==0) dfp=gen.getToday("yyyy");
            if(dfp.length()>0 && gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")){
                 TPX=tp+"Y"+gen.gettable(request.getParameter("Y14"));
                 CDX=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S4")),dfp};
            }
            java.util.Vector data=sgen.getDataQuery(conn,TPX,CDX);
//            java.util.Vector data=sgen.getDataQuery(conn,tp+gen.gettable(request.getParameter("Y14")),new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S4"))});
       // System.out.println(TPX);
        ses.setAttribute("PAY",data);
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
				<form class="form-horizontal" name="BGA" method="POST" action="ARDetail.jsp?tp=<%=tp%>" >
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">&nbsp;Curr:<b><%=gen.gettable(request.getParameter("S4"))%></b></LABEL>                                                                
										   <label class="control-label">&nbsp;Bill To:<b><%=Gen.gettable(request.getParameter("S1"))%>&nbsp;(<%=Gen.gettable(request.getParameter("S2"))%>)</b></LABEL>
                                           <label class="control-label">&nbsp;Balance:<b><%=Gen.getNumberFormat(bb,2)%></b></LABEL>
                                           <label class="control-label">&nbsp;Pay status:<select  name="Y15" onchange="refresh();">
                                            <option value="Unpaid" <%if(gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Unpaid")) out.print("selected");%>>Unpaid</option>
                                            <option value="Paid" <%if(gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")) out.print("selected");%>>Paid</option>
                                            </select>
                                            &nbsp;Paid Year:<input type="text" name="P3" size="4" maxlength="4" value="<%=dfp%>" onchange="refresh();">
                                            </LABEL>
                                            <label class="control-label">&nbsp;*Paid Date:<input class="input-medium date-picker" name="P"  id="P" type="text" data-date-format="dd-mm-yyyy" value="<%=p%>" placeholder="dd-mm-yyyy"/></LABEL>
                                            <label class="control-label">&nbsp;Pay No.:<input type="text" name="P1" size="15" maxlength="20" value="<%=Gen.gettable(request.getParameter("P1"))%>" ></LABEL>
                                            <label class="control-label">&nbsp;Ref. No.:<input type="text" name="P2" size="15" maxlength="20" value="<%=Gen.gettable(request.getParameter("P2"))%>" ></LABEL>
                                           <label class="control-label">&nbsp;Payment To:<select name="S7" >
                                                                <option></option>
                                                                <%for(int m=0;m<bank.size();m+=2){%>
                                                                    <option value="<%=gen.gettable(bank.get(m))%>" <%if(gen.gettable(bank.get(m)).trim().equalsIgnoreCase(gen.gettable(request.getParameter("S7")).trim())) out.print("selected");%>><%=gen.gettable(bank.get(m+1)).trim()%></option>            
                                                                <%}%>
                                                                <option value="Contra">Contra</option>
                                                            </select> </LABEL>
                                           <label class="control-label">&nbsp;Contra No:
                                                <input type="text" name="C0" size="10" maxlength="10"  value="<%=gen.gettable(request.getParameter("C0"))%>" >
                                   				<input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('CONTRA','C0','','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                           </LABEL>
                                     </div>
                                 </div>
                               </div>
                             </div>
                          </div>

						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>													
                                                        <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%if(s==4 &&!gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")) out.print("<th>WITHOUT TAX</th>");%>
                                                        <%}%>
                                                        <% if(!gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")){%> 
                                                        <th>WITHOUT TAX</th>
                                                        <th>WITH TAX</th>
                                                        <%}%>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){
                                                        if(hic>=100) break;
                                                        double bal=gen.getformatdouble(data.get(s+4))-gen.getformatdouble(data.get(s+6));
                                                        if(!gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid") && bal!=0){                                                            
                                                        }else if(gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid") && bal==0){
                                                        }else{
                                                            continue;
                                                        }
                                                        boolean canedit=false;
                                                        if(gen.gettable(data.get(s+7)).equalsIgnoreCase("1")) canedit=true;
                                                   %>         
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                            
                                                       %>
                                                            <td <%if(ss==3 ||ss==4 ||ss==6) out.print("align=right");%>>
                                                                <%if(ss!=3 && ss!=4 && ss!=6){
                                                                    if(ss==1 && canedit){%>
                                                                    <a href="ARPay.jsp?tp=ARPAY&canedit=<%=canedit%>&Y10=<%=y10%>&Y11=<%=y11%>&Y14=<%=Gen.gettable(request.getParameter("Y14"))%>&S1=<%=Gen.gettable(request.getParameter("S1"))%>&S2=<%=Gen.gettable(request.getParameter("S2"))%>&S3=<%=Gen.gettable(request.getParameter("S3"))%>&S4=<%=Gen.gettable(request.getParameter("S4"))%>&S5=<%=Gen.gettable(data.get(s))%>&S6=<%=Gen.gettable(data.get(s+1))%>&S7=<%=Gen.gettable(data.get(s+4))%>&S9=<%=Gen.gettable(data.get(s+2))%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                                    <%}else{
                                                                        out.print(gen.gettable(data.get(s+ss)).trim());
                                                                    }
                                                                }else{
                                                                 out.print(gen.getNumberFormat(data.get(s+ss),2));
                                                                }
                                                            %>
                                                            </td>
                                                            <%if(ss==4 && !gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")){
                                                                String balx=gen.getNumberFormat(""+Math.round(0.98*gen.getformatdouble(data.get(s+4))),2);
                                                            %><td align=right><%=balx%></td><%}%>
                                                        <%}%>
                                                        <%if(!gen.gettable(request.getParameter("Y15")).equalsIgnoreCase("Paid")){%>
                                                        <td>
                                                        <%if(bal!=0 && canedit){%>
                                                        <input type="checkbox" name="A<%=hic%>" value="ON" >
                                                            <%}%> 
                                                        </td>
                                                        <td>
                                                        <%if(bal!=0 && canedit){%>
                                                        <input type="checkbox" name="B<%=hic%>" value="ON" >
                                                            <%}%> 
                                                        </td>
                                                        <%}%> 
												</tr>
                                                <% hic++;
                                                }%>
											</tbody>
										</table>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
                            <div class="row" align=center>
                      		<button class="btn btn-info" type="button" onclick="VALID();">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                                            <input type="hidden" name="S1" value="<%=Gen.gettable(request.getParameter("S1"))%>" >
                                            <input type="hidden" name="S2" value="<%=Gen.gettable(request.getParameter("S2"))%>" >
                                            <input type="hidden" name="S3" value="<%=Gen.gettable(request.getParameter("S3"))%>" >
                                            <input type="hidden" name="S4" value="<%=gen.gettable(request.getParameter("S4"))%>" >
                                            <input type="hidden" name="S5" value="" ><!--SEQ-->
                                            <input type="hidden" name="S6" value="" ><!--JOBNO-->
                                        <!--    <input type="hidden" name="S7" value="" >-->
                                            <input type="hidden" name="S8" value="" ><!--BAL-->
                                            <input type="hidden" name="S9" value="" ><!--ACCT-->
                                            <input type="hidden" name="Y14" value="<%=gen.gettable(request.getParameter("Y14"))%>" >
                                            <input type="hidden" name="act" value="" >
                        </div>

						</div><!-- /.row -->
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
            function  VALID(){
                if(document.BGA.P.value==''){
                    alert("Please Fill The Paid Date!");
                    return;
                }else if(document.BGA.S7.value==''){
                    alert("Please Fill The Payment Method!");
                    return;
                }
                document.BGA.act.value="Save";
                BGA.submit();
            }
            function  refresh(){
                      BGA.submit();
            }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
ÿ ht?>
