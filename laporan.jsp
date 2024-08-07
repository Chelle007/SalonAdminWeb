<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
    <jsp:include page="title.jsp" flush ="true"/>
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
          String[] judul=new String[]{"JOBNO","SALES CODE","TYPE","DATE","BL NO.","VENDOR","CUSTOMER","SALES AMOUNT","COST AMOUNT","PROFIT"}; 
          java.util.Vector data=new java.util.Vector();     
          String st=gen.gettable(request.getParameter("Y11"));
          String end=gen.gettable(request.getParameter("Y12"));
          java.util.Vector combo1=new java.util.Vector();
          java.util.Vector combo2=new java.util.Vector();
          String tpx=tp;
            String f1=gen.gettable(request.getParameter("Y10"));
            String f2=gen.gettable(request.getParameter("Y11"));
            String f3=gen.gettable(request.getParameter("Y12"));
          if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPBANK")){       //
         // System.out.println("2");
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
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            combo2=sgen.getDataQuery(conn,"MSTBANK",new String[0]);
            if(request.getParameter("Y12")==null ||f3.length()==0){
                if(combo2.size()>0) f3=gen.gettable(combo2.get(0));            
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
               f2=gen.getToday("yyyy");
            }
            cond=new String[]{f1,f2,f3};
            title="Bank and Cash";//[TrxDate],[Seq],[Bank],[Credit],[Debit],[TrxType],[refcode],[Remarks] 
            judul=new String[]{"DATE","SEQ","ACCOUNT NO","DESCRIPTION","REMARK","CREDIT","DEBIT","TYPE","REF. NO"};
            
           
            data=sgen.getDataQuery(conn,tpx,cond);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"[TrxDate],[seq],[Acct],description,remark,[Credit],[Debit],[Type],[RefNo],");                  
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPSTOCK")){   
                //[ITEM_ID],[ITEM_DESC],[CATEGORY],[QUANTITY],[IN ML],[PURCHASE_PRICE_PER_UNIT],[SALES_PRICE_PER_UNIT_1],[MINIMUM_STOCK] FROM [ITEM]"/>
            title="Stock";//
            judul=new String[]{"ITEM_ID","ITEM_DESC","CATEGORY","START STOCK","REMAIN STOCK","IN ML","PURCHASE_PRICE_PER_UNIT","SALES_PRICE_PER_UNIT_1","MINIMUM_STOCK"};
            
            data=sgen.getDataQuery(conn,tpx,new String[0]);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"[ITEM_ID],[ITEM_DESC],[CATEGORY],[START STOCK],[REMAIN STOCK],[VOLUME_PER_UNIT],[PURCHASE_PRICE_PER_UNIT],[SALES_PRICE_PER_UNIT_1],[MINIMUM_STOCK],");                  
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPPURCHASE")){   
            title="Purchasing";//
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
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
               f2=gen.getToday("yyyy");
            }
            cond=new String[]{f1,f2};
            judul=new String[]{"[PURCHASE_ID]","[PURCHASE_DATE]","[SUPPLIER_ID]","SUPPLIER_NAME","[TOTAL_PURCHASE_PRICE]","[TOTAL_COST_PRICE]","[TOTAL_DISCOUNT_AMOUNT]","[PAYMENT_DUE_DATE]","[REMARK]","[BANK_ID]","[paiddate]"};
            
            data=sgen.getDataQuery(conn,tpx,cond);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"[PURCHASE_ID],[PURCHASE_DATE],[SUPPLIER_ID],SUPPLIER_NAME,[TOTAL_PURCHASE_PRICE],[TOTAL_COST_PRICE],[TOTAL_DISCOUNT_AMOUNT],[PAYMENT_DUE_DATE],[REMARK],[BANK_ID],[PAIDDATE],");                  
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPSALES")){   
            title="Sales";//
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
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
               f2=gen.getToday("yyyy");
            }
            cond=new String[]{f1,f2};
            judul=new String[]{"[SALES_ID]","[SALES_DATE]","[MEMBER_NAME]","[AGENT_NAME]","[TOTAL_SALES]","[TOTAL_DISCOUNT_AMOUNT]","[REMARK]","[BANK_NAME]"};
            
            data=sgen.getDataQuery(conn,tpx,cond);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"[SALES_ID],[SALES_DATE] ,MEMBER_NAME ,AGENT_NAME,[TOTAL_PRICE],[TOTAL_DISCOUNT_AMOUNT], [REMARK],BANK_NAME,");                  
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPTREATMENT")){   
            title="Treatment";//
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
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
               f2=gen.getToday("yyyy");
            }
            cond=new String[]{f1,f2};
            judul=new String[]{"[ID]","[DATE]","MEMBER_NAME","[SALES_ID]","CARD_NAME","CARD NO","[TOTAL_TREATMENT]","[MATERIAL_COST]","TOTAL_DISC","[REMARK] "};
            
            data=sgen.getDataQuery(conn,tpx,cond);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"[ID],[TREATMENT_DATE],MEMBER_NAME,[SALES_ID],CARD_NAME,CARD NO,[TOTAL_TREATMENT],[TOTAL_MATERIAL_COST],TOTAL_DISC,[REMARK],");                  
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPFINANCE")){   
            title="Gain/Loss";//
            judul=new String[]{"YEAR"," MONTH","TOTAL SALES","TOTAL AGENT FEE","TOTAL COMMISSION","TOTAL MATERIAL ITEM","TOTAL TREATMENT MATERIAL","GAIN/LOSS"};
            java.util.Vector judulx=gen.getElement(',',"YEAR, MONTH, TOTAL SALES, TOTAL AGENT FEE, TOTAL COMMISSION,TOTAL MATERIAL ITEM, TOTAL TREATMENT MATERIAL,GAIN/LOSS,");                  
            if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("2")){
                tpx="REPAGENTFEE";
                judul=new String[]{"AGENT ID","AGENT NAME","TOTAL FEE"};
                judulx=gen.getElement(',',"AGENT ID, AGENT NAME, TOTAL FEE,");                  
            }else if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("3")){
                tpx="REPCOMMISION";
                judul=new String[]{"EMPLOYEE ID","EMPLOYEE NAME","COMMISSION"};
                judulx=gen.getElement(',',"EMPLOYEE ID, EMPLOYEE NAME,COMMISSION,");                  
            }
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
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
               f2=gen.getToday("yyyy");
            }
            cond=new String[]{f1,f2};
            if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("1") ||gen.gettable(request.getParameter("Y12")).length()==0){
                cond=new String[0];
            }
            data=sgen.getDataQuery(conn,tpx,cond);      
                   
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  //java.util.Vector datax=sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",data);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
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
											<form class="form-horizontal" name="BGA" method="POST" action="laporan.jsp" >
<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPFINANCE") || gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPBANK") || gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPPURCHASE")||gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPSALES")||gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPTREATMENT")){%>
                                            <div class="form-group">
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(f1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<input type="text" id="Y11" maxlength="4" size="4" name="Y11" value="<%=f2%>"  placeholder="Year">  </label>                                                
                                            <%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPBANK")){%>
                                            <label class="control-label">&nbsp;Bank:<select name="Y12" onchange="refresh();">
                                                                <%for(int m=0;m<combo2.size();m=m+2){%>
                                                                  	<option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(f3.trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m+1)).trim()%></option>
                                                                <%}%>
                                                                </select>  
                                                </label>  
                                             <%}%>   
                                            <%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPFINANCE")){%>
                                            <label class="control-label">&nbsp;Report:<select name="Y12" onchange="refresh();">
                                                                <option value="1" <%if(gen.gettable(request.getParameter("Y12")).trim().equalsIgnoreCase("1")) out.print("selected");%>>GAIN/LOSS</option>
                                                                <option value="2" <%if(gen.gettable(request.getParameter("Y12")).trim().equalsIgnoreCase("2")) out.print("selected");%>>AGENT FEE</option>
                                                                <option value="3" <%if(gen.gettable(request.getParameter("Y12")).trim().equalsIgnoreCase("3")) out.print("selected");%>>COMMISSION</option>
                                                                </select>  
                                                </label>  
                                             <%}%>   
                                            </div>
<%}else if(!gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPSTOCK")){%>                                            
											<div class="form-group">
												
                                                <label class="control-label">
                                                    &nbsp;&nbsp;Date From:<input class="input-medium date-picker" name="Y11"  id="Y11" type="text" data-date-format="dd-mm-yyyy" value="<%=st%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
													&nbsp;&nbsp;Date To:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=end%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
                                                </label>                                                                   
                                            </div>
<%}%>
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
                                                            <%if(judul[ss].endsWith("STOCK")||judul[ss].endsWith("AMOUNT]")||judul[ss].startsWith("AMOUNT")||judul[ss].startsWith("TOTAL")||judul[ss].startsWith("[TOTAL")||judul[ss].startsWith("SALES_PRICE")||judul[ss].startsWith("PURCHASE_PRICE")||judul[ss].startsWith("GAIN/LOSS")||judul[ss].startsWith("COMMISSION")||judul[ss].startsWith("DEBIT")||judul[ss].startsWith("CREDIT")||judul[ss].endsWith("COST]")){%>
                                                            <td align=right nowrap><%=gen.getNumberFormat(data.get(s+ss),0)%></td>
                                                            <%}else{%>
                                                                <td nowrap><%=gen.gettable(data.get(s+ss)).trim()%></td>
                                                            <%}%>
                                                        <%}%>
													</tr>
                                                    <%}%>
												</tbody>
											</table>
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
			
					//"iDisplayLength": 50
			
			
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
            function onact(Parm1,Parm2,Parm3){
            	window.open("viewdokumen.jsp?tp=<%=gen.gettable(request.getParameter("tp"))%>&Y11="+Parm1+"&Y12="+Parm2+"&Y13="+Parm3,"Cetak Dokumen", "height=400,width=850,toolbar=no,scrollbars=YES,menubar=no");
            }
            
            function refresh(){
                BGA.submit();
            }
            function refr(){
                document.BGA.tp.value=document.BGA.Y.value;
                document.BGA.Y10.value="";
                document.BGA.Y20.value="";
                document.BGA.Y30.value="";
                BGA.submit();
            }
            function refre(){
                document.BGA.tp.value=document.BGA.Y.value;
                document.BGA.Y10.value="";
                document.BGA.Y1.value="";
                BGA.submit();
            }
            function down(){
                document.BGA.tpx.value="Download";
                BGA.submit();
            }
	function jump(P1,P2,P3,P4,P5,P6){
		url="movementc.jsp?tp="+P1+"&S1="+P2+"&S2="+P3+"&S3="+P4+"&S4="+P5+"&S5="+P6;
		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
	}
	function jumpJOB(P1){
		url="jobdetailnew.jsp?tp=JOBNEWDETAIL&menu=false&canedit=true&S1="+P1;
		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
	}
        	function jumpBL(P0,P1,P2,P3,P4,P5,P6){
        		url="movementc.jsp?tp="+P0+"&S1="+P1+"&S2="+P2+"&S3="+P3+"&S4="+P4+"&S5="+P5+"&S7="+P6+"&S6="+document.BGA.Y10.value+"&S8="+document.BGA.Y11.value+"&S9="+document.BGA.Y12.value;
        		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
        	}
            
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            
		</script>
	</body>
</html>
