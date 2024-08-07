<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>GPP Admin</title>

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
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
        java.util.Vector vk=(java.util.Vector)ses.getAttribute("User");
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
          String title="Konfirmasi Pembayaran";       
          String[] cond=new String[]{"%"+sgen.getUserId(vk)+"%"};
          if(sgen.getUserType(vk).equalsIgnoreCase("A")){//admin
            cond[0]="%%";
          }
          String msg="";
          if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){
         // System.out.println("indel");
            msg=sgen.update(conn,"FILEDELETE",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("id"))});
            msg=sgen.update(conn,"LOGMENUADD",new String[]{sgen.getUserId(vk),"FILEDELETE"});

            if(msg.length()>0){
                msg="(Delete Failed!!"+msg+")";
            }     
          }
          if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("APR")){//APPROVE          
            msg=sgen.update(conn,"FILEUPDATE",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("id"))});
            msg=sgen.update(conn,"HISTORYFILEUPDATE",new String[]{gen.gettable(request.getParameter("Y11"))});
            msg=sgen.update(conn,"LOGMENUADD",new String[]{sgen.getUserId(vk),"FILEAPPROVE"});
            if(msg.length()>0){
                msg="(Delete Failed!!"+msg+")";
            }else{
            
                java.util.Vector mastermember=sgen.getDataQuery(conn,"LOGIN",new String[]{gen.gettable(request.getParameter("Y11"))});
                if(mastermember.size()>0){
                    java.util.Vector dtl=sgen.getDataQuery(conn,"UPLTRFDETAIL1",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("id"))});
                    if(gen.gettable(mastermember.get(6)).trim().equalsIgnoreCase("F")){
                        java.util.Vector history=sgen.getDataQuery(conn,"UPLTRFLAST",new String[]{gen.gettable(request.getParameter("Y11"))});
                        java.util.Vector tmps=new java.util.Vector();
                        int mth=gen.getInt(gen.getToday("MM"));
                        int yr=gen.getInt(gen.getToday("yyyy"));
                        int amt=gen.getInt(mastermember.get(14));
                        if(history.size()>0){
                            mth=gen.getInt(history.get(0))+1;
                            yr=gen.getInt(history.get(1));
                            if(mth>12){
                                yr++;
                                mth=1;
                            }
                        }
                        int tot=gen.getInt(request.getParameter("amt"));
                        double jl=tot/amt;
                        int jmlbulan=(int)Math.round(jl);
                        for(int st=1;st<=jmlbulan;st++){
                            msg=sgen.update(conn,"HISTORYMEMBERADD",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("id")),""+mth,""+yr,""+amt,""});//
                            mth++;
                            if(mth>12){
                                yr++;
                                mth=1;
                            }
                        }
                        
                    }else{
                        msg=sgen.update(conn,"HISTORYMEMBERADD",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("id")),gen.getToday("MM"),gen.getToday("yyyy"),gen.gettable(request.getParameter("amt")),""});//
                    }
                    if(dtl.size()>0){
                        msg=sgen.update(conn,"BIAYAADDAUTO",new String[]{gen.gettable(dtl.get(1)).trim(),"Setoran "+gen.gettable(mastermember.get(0)).trim(),gen.gettable(dtl.get(0)).trim(),"0",sgen.getUserId(vk)});
                    }
                    if(gen.gettable(mastermember.get(4)).trim().length()>0 && dtl.size()>0){
                        String tit="Ibu";
                        if(gen.gettable(mastermember.get(12)).trim().equalsIgnoreCase("M")){
                            tit="Bapak";
                        }
                        String SB="<table><tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3>Salam sejahtera untuk "+tit+" "+gen.gettable(mastermember.get(0)).trim()+", kami dari team GPP (Gerakan Peduli Pendidikan) Batam.</td></tr><tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3>&nbsp;</td></tr>"
                        +"<tr><td colspan=3>Donatur yang baik hati, kami telah menerima bantuan anda sebesar Rp "
                        + gen.getNumberFormat(dtl.get(0),0)+",pada tanggal "+gen.gettable(dtl.get(1)).trim()
                        +"</td></tr><tr><td colspan=3>&nbsp;</td></tr>"
                        +"<tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3>Segenap team GPP dan anak-anak sekolah mengucapkan terima kasih sebesar-besarnya atas bantuan anda, kami doakan anda selalu sehat sejahtera.</td></tr>"
                        +"</td></tr><tr><td colspan=3>&nbsp;</td></tr>"
                        +"<tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3>Salam Bahagia</td></tr>"
                        +"<tr><td colspan=3>&nbsp;</td></tr><tr><td colspan=3><b>&nbsp;&nbsp;Team GPP</b></td></tr>"
                        +"</table>";
                        new com.ysoft.Mailer().sendMail(new String[]{gen.gettable(mastermember.get(4)).trim()},"Terima Kasih atas partisipasi Saudara",SB);
                    }
                                        
                }
            }     
          }
          String[] judul=new String[]{"Id Transfer","Id Donatur","Nama Donatur","Tanggal Transfer","Jumlah Transfer","Nama File","Keterangan"};  //
        java.util.Vector data=sgen.getDataQuery(conn,tp,cond);     
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>

	<body class="no-skin">
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">

						<div class="page-header">
							<h1>
									<%=title%>  <%=msg%>
							</h1>
						</div><!-- /.page-header -->

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
														<th class="center">
															<label class="pos-rel">
																<input type="checkbox" class="ace" />
																<span class="lbl"></span>
															</label>
														</th>
                                                        <%for(int s=0;s<judul.length;s++){%>         
														<th><%=judul[s]%></th>
                                                        <%}%>
														<th></th>
													</tr>
												</thead>

												<tbody>
                                                   <%for(int s=0;s<data.size();s+=judul.length){%>         
													<tr>
														<td class="center">
															<label class="pos-rel">
																<input type="checkbox" class="ace" />
																<span class="lbl"></span>
															</label>
														</td>
                                                       <%for(int ss=0;ss<judul.length;ss++){%>         
														
                                                            <%if(ss==4){%>
                                                            <td align=right><%=gen.getNumberFormat(data.get(s+ss),0)%></td>
                                                            <%}else if(ss==5){%>
                                                            <td><a href="javascript:jump('<%=gen.gettable(data.get(s+5)).trim()%>')"><%=gen.gettable(data.get(s+ss)).trim()%></a></td>
                                                            <%}else{%>
                                                            <td><%=gen.gettable(data.get(s+ss)).trim()%></td>
                                                            <%}%>
                                                        <%}%>
														<td>
															<div class="hidden-sm hidden-xs action-buttons">
																<a class="green" href="javascript:apprv('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+4)).trim()%>')">
																	<i class="ace-icon fa fa-hand-o-right bigger-130"></i>
																</a>
																<a class="red" href="javascript:del('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>')">
																	<i class="ace-icon fa fa-trash-o bigger-130"></i>
																</a>
															</div>

														</td>
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
	function jump (Parm){
		window.open("dokument/transfer/"+Parm,"","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
	}
            function del(Parm1,Parm2){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="UploadBukti.jsp?tp=UPLTRF&act=DEL&id="+Parm1+"&Y11="+Parm2;
                }
            }
            function apprv(Parm1,Parm2,Parm3){
                if(confirm("Approve Selected Record?","Approve")){
                    location.href="UploadBukti.jsp?tp=UPLTRF&act=APR&id="+Parm1+"&Y11="+Parm2+"&amt="+Parm3;
                }
            }
            
    
			jQuery(function($) {
				//initiate dataTables plugin
				var myTable = 
				$('#dynamic-table')
				//.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
				.DataTable( {
					bAutoWidth: false,
					"aoColumns": [
					  { "bSortable": false },
					  null, null,null, null, null, null, null,
					  { "bSortable": false }
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
		</script>
	</body>
</html>
