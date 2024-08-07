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
          String title="Balance Container";       
          
          java.util.Vector status=sgen.getDataQuery(conn,"STATUSUNIONALL",new String[0]);
          java.util.Vector ttamp=new java.util.Vector();
          String sts1[]=new String[]{"DEPO/STATUS","20FR","20GP","20HQ","20OT","40FR","40GP","40HQ","40OT"}; 
          for(int m=0;m<status.size();m+=2){
             String sts[]=new String[]{"DF","FC","RE"};
             if(gen.gettable(status.get(m)).trim().startsWith("REPO") && gen.gettable(status.get(m+1)).equalsIgnoreCase("I")){//repo in
                sts=new String[]{"DE","TE","RE"};
             }else if(gen.gettable(status.get(m)).trim().startsWith("REPO") && gen.gettable(status.get(m+1)).equalsIgnoreCase("O")){//repo in
                sts=new String[]{"TE","RE","OE"};
             }else if(gen.gettable(status.get(m)).trim().startsWith("EXPORT")){//EXPORT
                sts=new String[]{"ES","FL","OF"};
             }
             String[] cond=new String[]{"B",gen.gettable(status.get(m))};
             String[] cond2=new String[]{"W",gen.gettable(status.get(m))};
             
             String tpx="BALMOVE"+gen.gettable(status.get(m+1));
            String st=gen.gettable(request.getParameter("Y11"));
            String end=gen.gettable(request.getParameter("Y12"));
            if(st.length()>0 && end.length()>0){
                tpx=tpx+"3";
                cond=new String[]{"B",gen.gettable(status.get(m)),st,end};
                cond2=new String[]{"W",gen.gettable(status.get(m)),st,end};
            }else if(st.length()>0){
                tpx=tpx+"1";
                cond=new String[]{"B",gen.gettable(status.get(m)),st};
                cond2=new String[]{"W",gen.gettable(status.get(m)),st};
            }else if(end.length()>0){
                tpx=tpx+"2";
                cond=new String[]{"B",gen.gettable(status.get(m)),end};
                cond2=new String[]{"W",gen.gettable(status.get(m)),end};
            }             
            
            java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
            java.util.Vector data1=sgen.getDataQuery(conn,tpx,cond2);
            if(data.size()>0){
                ttamp.addElement("B/"+status.get(m));
                ttamp.addElement(gen.gettable(status.get(m+1)));
                
                for(int mo=2;mo<sts1.length;mo++)ttamp.addElement("");
                for(int mx=0;mx<sts.length;mx++){
                    ttamp.addElement(sts[mx]);
                    for(int mh=1;mh<sts1.length;mh++){
                        String cc="0";
                        for(int ms=0;ms<data.size();ms+=3){
                            if(gen.gettable(data.get(ms)).trim().equalsIgnoreCase(sts1[mh]) &&gen.gettable(data.get(ms+1)).trim().equalsIgnoreCase(sts[mx])){
                                cc=gen.gettable(data.get(ms+2));
                            }
                        }                    
                        ttamp.addElement(cc);
                    }
                }
                
            }
            if(data1.size()>0){
                ttamp.addElement("W/"+status.get(m));
                ttamp.addElement(gen.gettable(status.get(m+1)));
                for(int mo=2;mo<sts1.length;mo++)ttamp.addElement("");
                for(int mx=0;mx<sts.length;mx++){
                    ttamp.addElement(sts[mx]);
                    for(int mh=1;mh<sts1.length;mh++){
                        String cc="0";
                        for(int ms=0;ms<data1.size();ms+=3){
                            if(gen.gettable(data1.get(ms)).trim().equalsIgnoreCase(sts1[mh]) &&gen.gettable(data1.get(ms+1)).trim().equalsIgnoreCase(sts[mx])){
                                cc=gen.gettable(data1.get(ms+2));
                            }
                        }                    
                        ttamp.addElement(cc);
                    }
                }
                
            }
            if(gen.gettable(status.get(m)).trim().startsWith("S")){
            
                cond2[0]="S";
                data1=sgen.getDataQuery(conn,tpx,cond2);
                if(data1.size()>0){
                    ttamp.addElement("S/"+status.get(m));
                    ttamp.addElement(gen.gettable(status.get(m+1)));
                    for(int mo=2;mo<sts1.length;mo++)ttamp.addElement("");
                    for(int mx=0;mx<sts.length;mx++){
                        ttamp.addElement(sts[mx]);
                        for(int mh=1;mh<sts1.length;mh++){
                            String cc="0";
                            for(int ms=0;ms<data1.size();ms+=3){
                                if(gen.gettable(data1.get(ms)).trim().equalsIgnoreCase(sts1[mh]) &&gen.gettable(data1.get(ms+1)).trim().equalsIgnoreCase(sts[mx])){
                                    cc=gen.gettable(data1.get(ms+2));
                                }
                            }                    
                            ttamp.addElement(cc);
                        }
                    }
                    
                }
            }//end Soc
         } 
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=new java.util.Vector();
                  for(int mt=0;mt<sts1.length;mt++) judulx.addElement(sts1[mt]);//gen.getElement(',',"[tpContainer],[ContNo] ,[BLNo],[Status],[feeder],[TypeCode] ,[Cosignee],[Cosignee Name],[STS],[DischDate] ,[CosigPickDate],[ReturnInDepotDate] ,[Remark],[Doc],[Shipper],[Shipper Name],[Status2],[GetOutDate] ,[GetInPortDate],[LoadOnFeederDate] ,[vsl],[EtdBtmDate],[EtaSinDate],[SealNo],[BLNO2],[DM],[ExpBL],[ExpCode] ,[ExpDept] ,[ExpTrade] ,[ImpBL] ,[ImpCode],[ImpDept],[ImpTrade],[Service],[POD],");                  
                  ses.setAttribute("DATAXLS",ttamp);
                  ses.setAttribute("JUDULXLS",judulx);
                  java.util.Vector jdx=new java.util.Vector();
                  for(int mt=0;mt<sts1.length;mt++){
                    if(mt==0) jdx.addElement("0"); else jdx.addElement("1");
                  }
                  ses.setAttribute("NUMBERXLS",jdx);
                  bd.doAll(request);
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
											<form class="form-horizontal" name="BGA" method="POST" action="BalanceContainer.jsp" >
                                                <label class="control-label">
                                                    &nbsp;&nbsp;Discharge Date From:<input class="input-medium date-picker" name="Y11"  id="Y11" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y11"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
													&nbsp;&nbsp;To:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
                                                </label>                                                                   
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

										<div>
											<table id="dynamic-table" class="table table-striped table-bordered table-hover">
												<thead>
													<tr>
                                                    <%for(int m=0;m<sts1.length;m++){%>
                                                    	<th><%=sts1[m]%></th>
                                                    <%}%>
													</tr>
												</thead>
												<tbody>
                                                       <%
                                                       String stp="",size="",sstatus="",type="",ss="",inout="";
                                                       for(int m=0;m<ttamp.size();m+=sts1.length){
                                                            java.util.Vector ps=gen.getElement('/',gen.gettable(ttamp.get(m))+"/");
                                                            
                                                            if(ps.size()>1){
                                                                stp=gen.gettable(ps.get(0));
                                                                sstatus=gen.gettable(ps.get(1));
                                                                inout=gen.gettable(ttamp.get(m+1));
                                                                ss="";
                                                            }else{
                                                                ss=gen.gettable(ttamp.get(m));
                                                            }
                                                                                                                        
                                                       %>
    													<tr>
                                                              <%for(int mt=0;mt<sts1.length;mt++){
                                                                    if(mt>0 && gen.getInt(ttamp.get(mt+m))>0){
                                                                        size=sts1[mt].substring(0,2);
                                                                        type=sts1[mt].substring(2);
                                                                        String tps="CONTAINER16";
                                                                        if(inout.startsWith("O")) tps="CONTAINER17";
                                                                    %>
                                                                    <td nowrap><a href="javascript:jump('<%=tps%>','<%=sstatus%>','<%=stp%>','<%=type%>','<%=size%>','<%=ss%>')"><%=gen.gettable(ttamp.get(mt+m))%></a></td>
                                                                    <%}else{%>
                                                                    <td nowrap><%=gen.gettable(ttamp.get(mt+m))%></td>
                                                             <%     }
                                                             }%>                                                                    
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
            function down(){
                document.BGA.tpx.value="Download";
                BGA.submit();
            }
        	function jump(P0,P1,P2,P3,P4,P5){
        		url="movementc.jsp?tp="+P0+"&S1="+P1+"&S2="+P2+"&S3="+P3+"&S4="+P4+"&S5="+P5+"&S6="+document.BGA.Y11.value+"&S7="+document.BGA.Y12.value;
        		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
        	}
            
            
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            
		</script>
	</body>
</html>
