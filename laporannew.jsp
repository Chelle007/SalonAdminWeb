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
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
          String title="Movement For Chart";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode"))};
          String[] judul=new String[]{"TYPE","JOBNO","DATE","ACCOUNT","DESCRIPTION","IDR AMOUNT","VENDOR","BILLTO","CUSTOMER"}; 
          java.util.Vector data=new java.util.Vector();     
          java.util.Vector combo1=new java.util.Vector();
          java.util.Vector combo2=new java.util.Vector();
          String tpx=tp;
          String st=gen.gettable(request.getParameter("Y10"));
          String sts=gen.gettable(request.getParameter("Y20"));
            //String cont=gen.gettable(request.getParameter("T1")).trim();
          
          //System.out.println(gen.gettable(request.getParameter("tp")));
          if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPDATACHART")){       //
            tpx=tp+"1";//monthly import
            judul=new String[]{"IMPORT","SIZE","TYPE","","","","","","","","","","","",""};
            if(st.length()==0 && request.getParameter("Y10")==null){
                st=gen.getToday("yyyy");
            }
            String month[]=new String[]{"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
            for(int xt=0;xt<=11;xt++)judul[xt+3]=month[xt]+"-"+st.substring(2);
            combo1=sgen.getDataQuery(conn,"STATUS1BYYEAR",new String[]{st});
            if (!gen.gettable(request.getParameter("Y30")).equalsIgnoreCase("E")){
                if(sts.length()==0){
                  for(int mt=0;mt<combo1.size();mt++){
                        sts+=gen.gettable(combo1.get(mt)).trim()+",";
                  }
                }
            }
            if (gen.gettable(request.getParameter("Y30")).equalsIgnoreCase("E")){
                judul[0]="EXPORT";
                combo1=sgen.getDataQuery(conn,"STATUS2BYYEAR",new String[]{st});
                if(sts.length()==0){                  
                  for(int mt=0;mt<combo1.size();mt++){
                        sts+=gen.gettable(combo1.get(mt)).trim()+",";
                  }
                }
                
                tpx=tp+"2";
                if (gen.gettable(request.getParameter("Y40")).equalsIgnoreCase("W")){
                    tpx=tp+"4";
                }                        
            }else if (gen.gettable(request.getParameter("Y40")).equalsIgnoreCase("W")){
                tpx=tp+"3";
            }        
            java.util.Vector wy=sgen.getDataQuery(conn,"WEEKTHISYEAR",new String[]{"31-12-"+st});
            String lastw="52";  
            if(wy.size()>0){
              lastw=gen.gettable(wy.get(0));
            }
            if (gen.gettable(request.getParameter("Y40")).equalsIgnoreCase("W")){
                judul=new String[3+gen.getInt(lastw)];
                judul[0]="IMPORT";
                if (gen.gettable(request.getParameter("Y30")).equalsIgnoreCase("E")){
                    judul[0]="EXPORT";
                }
                judul[1]="SIZE";
                judul[2]="TYPE";
                for(int xt=0;xt<gen.getInt(lastw);xt++)judul[xt+3]=(xt+1)+st.substring(2);
            }
            
                        
            combo2=sgen.getDataQuery(conn,"MOVEMENTYEAR",new String[0]);
            
            
            java.util.Vector tmp=new java.util.Vector();
            java.util.Vector tmpxl=new java.util.Vector();
            java.util.Vector rowdata=new java.util.Vector();
            rowdata.addElement("20");      
            rowdata.addElement("GP");
            rowdata.addElement("20");
            rowdata.addElement("FR");
            rowdata.addElement("20");
            rowdata.addElement("OT");
            rowdata.addElement("40");
            rowdata.addElement("GP");
            rowdata.addElement("40");
            rowdata.addElement("HQ");
            rowdata.addElement("40");
            rowdata.addElement("FR");
            rowdata.addElement("40");
            rowdata.addElement("OT");
            //System.out.println("data.size()>"+data.size());
            java.util.Vector tmpc=gen.getElement(',',sts+",");
            if (!gen.gettable(request.getParameter("Y40")).equalsIgnoreCase("W")){
            //[status],size,typecode,month(trxdate),year(trxdate)
                for(int stx=0;stx<tmpc.size();stx++){
                  
                  String sts1=gen.gettable(tmpc.get(stx)).trim();
                  if(sts1.length()==0)continue;
                  cond=new String[]{sts1,st};
                  data=sgen.getDataQuery(conn,tpx,cond);
                  for(int mt=0;mt<rowdata.size();mt+=2){
                    if(mt==0)tmp.addElement(sts1);
                    else tmp.addElement("");
                    tmpxl.addElement(sts1);
                    tmpxl.addElement(rowdata.get(mt));
                    tmpxl.addElement(rowdata.get(mt+1));
                    tmp.addElement(rowdata.get(mt));
                    tmp.addElement(rowdata.get(mt+1));
                    for(int nt=3;nt<judul.length;nt+=1){
                      String cc="0";
                      for(int xt=0;xt<data.size();xt+=6){
                          if(gen.gettable(rowdata.get(mt)).equalsIgnoreCase(gen.gettable(data.get(xt+1)).trim())
                          &&gen.gettable(rowdata.get(mt+1)).equalsIgnoreCase(gen.gettable(data.get(xt+2)).trim())
                          &&gen.getInt(data.get(xt+3))==(nt-2) 
                          &&st.equalsIgnoreCase(gen.gettable(data.get(xt+4)).trim())
                          ){
                              cc=gen.gettable(data.get(xt+5));
                          }
                      }
                      tmp.addElement(cc);
                      tmpxl.addElement(cc);
                    }
                  }                    
                }
            }else{
                for(int stx=0;stx<tmpc.size();stx++){
                  String sts1=gen.gettable(tmpc.get(stx)).trim();
                  if(sts1.length()==0)continue;
                  cond=new String[]{sts1,st};
                  data=sgen.getDataQuery(conn,tpx,cond);
                  for(int mt=0;mt<rowdata.size();mt+=2){
                    if(mt==0)tmp.addElement(sts1);
                    else tmp.addElement("");
                    tmpxl.addElement(sts1);
                    tmpxl.addElement(rowdata.get(mt));
                    tmpxl.addElement(rowdata.get(mt+1));
                    tmp.addElement(rowdata.get(mt));
                    tmp.addElement(rowdata.get(mt+1));
                    for(int nt=3;nt<judul.length;nt+=1){
                      String cc="0";
                      for(int xt=0;xt<data.size();xt+=5){
                          if(gen.gettable(rowdata.get(mt)).equalsIgnoreCase(gen.gettable(data.get(xt+1)).trim())
                          &&gen.gettable(rowdata.get(mt+1)).equalsIgnoreCase(gen.gettable(data.get(xt+2)).trim())
                          &&gen.getInt(data.get(xt+3))==(nt-2) 
                          ){
                              cc=gen.gettable(data.get(xt+4));
                          }
                      }
                      tmp.addElement(cc);
                      tmpxl.addElement(cc);
                    }
                  }
                }            
            }                
            data=tmp;
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=new java.util.Vector();
                  for(int mt=0;mt<judul.length;mt++) judulx.addElement(judul[mt]);//gen.getElement(',',"[tpContainer],[ContNo] ,[BLNo],[Status],[feeder],[TypeCode] ,[Cosignee],[Cosignee Name],[STS],[DischDate] ,[CosigPickDate],[ReturnInDepotDate] ,[Remark],[Doc],[Shipper],[Shipper Name],[Status2],[GetOutDate] ,[GetInPortDate],[LoadOnFeederDate] ,[vsl],[EtdBtmDate],[EtaSinDate],[SealNo],[BLNO2],[DM],[ExpBL],[ExpCode] ,[ExpDept] ,[ExpTrade] ,[ImpBL] ,[ImpCode],[ImpDept],[ImpTrade],[Service],[POD],");                  
                  //java.util.Vector datax=tmpxl;//sgen.getDataQuery(conn,tpx1,cond);
                  ses.setAttribute("DATAXLS",tmpxl);
                  ses.setAttribute("JUDULXLS",judulx);
                  java.util.Vector jdx=new java.util.Vector();
                  for(int mt=0;mt<judul.length;mt++){
                    if(mt<=2) jdx.addElement("0"); else jdx.addElement("1");
                  }
                  ses.setAttribute("NUMBERXLS",jdx);
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
											<form class="form-horizontal" name="BGA" method="POST" action="laporannew.jsp" >
<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPDATACHART")){%>
                                            <div class="form-group">
        										<label class="control-label">*Year:
                                                                <select  name="Y10" onchange="refresh();">
                                                                <%for(int m=0;m<combo2.size();m++){%>
                                                                  	<option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(st.equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option>
                                                                <%}%>
                                                                </select>  
    															&nbsp;&nbsp;Status:
                                                                <input type="text" id="Y20" size="50" maxlength="100" name="Y20"  value="<%=sts%>" onchange="refresh();"/>                                                                
                                                </label>  
        										<label class="control-label">
                                                               &nbsp;&nbsp;Export/Import: <select  name="Y30" onchange="refreshY30();">
                                                                  	<option value="I" <%if(Gen.gettable(request.getParameter("Y30")).trim().equalsIgnoreCase("I")) out.print("selected");%>>IMPORT</option>
                                                                  	<option value="E" <%if(Gen.gettable(request.getParameter("Y30")).trim().equalsIgnoreCase("E")) out.print("selected");%>>EXPORT</option>
                                                                </select>  
                                                </label>  
        										<label class="control-label">
                                                               &nbsp;&nbsp;Monthly/Weekly: <select  name="Y40" onchange="refresh();">
                                                                  	<option value="M" <%if(Gen.gettable(request.getParameter("Y40")).trim().equalsIgnoreCase("M")) out.print("selected");%>>MONTHLY</option>
                                                                  	<option value="W" <%if(Gen.gettable(request.getParameter("Y40")).trim().equalsIgnoreCase("W")) out.print("selected");%>>WEEKLY</option>
                                                                </select>  
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
                                                   <%
                                                   String a="";
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
													<tr>
                                                       <%
                                                        if(gen.gettable(data.get(s)).length()!=0) a=gen.gettable(data.get(s));
                                                        for(int ss=0;ss<judul.length;ss++){
                                                                if(ss>2 && gen.getInt(data.get(s+ss))>0){                                                                    
                                                                    String tps="CONTAINER8";//untuk monthly import
                                                                    if (gen.gettable(request.getParameter("Y30")).equalsIgnoreCase("E")){
                                                                        tps="CONTAINER9";
                                                                    }
                                                                    if (gen.gettable(request.getParameter("Y40")).equalsIgnoreCase("W")){
                                                                        if (gen.gettable(request.getParameter("Y30")).equalsIgnoreCase("E")){
                                                                            tps="CONTAINER11";
                                                                        }else{
                                                                            tps="CONTAINER10";
                                                                        }
                                                                    }%>
                                                                <td nowrap><a href="javascript:jump('<%=tps%>','<%=a%>','<%=gen.gettable(data.get(s+1))%>','<%=gen.gettable(data.get(s+2))%>','<%=(""+(ss-2))%>','<%=st%>')"><%=gen.gettable(data.get(s+ss))%></a>                                                                    
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
            function refreshY30(){
                document.BGA.Y20.value="";
                BGA.submit();
            }
            function down(){
                document.BGA.tpx.value="Download";
                BGA.submit();
            }
        	function jump(P0,P1,P2,P3,P4,P5){
        		url="movementc.jsp?tp="+P0+"&S1="+P1+"&S2="+P2+"&S3="+P3+"&S4="+P4+"&S5="+P5;
        		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
        	}
            
            
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            
		</script>
	</body>
</html>
