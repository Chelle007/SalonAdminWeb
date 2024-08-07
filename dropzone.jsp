<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>GPP Admin</title>

		<meta name="description" content="Drag &amp; drop file upload with image preview" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->
		<link rel="stylesheet" href="assets/css/dropzone.min.css" />

		<!-- text fonts -->
		<link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
<link rel="stylesheet" href="assets/css/bootstrap-datepicker3.min.css" />
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
        com.ysoft.General Gen = new com.ysoft.General(); 
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
  		

%>
	<body class="no-skin">
           <jsp:include page="menu.jsp" flush ="true"/>

			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>
							    Upload  <%if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("G")){%> Foto Anggota <%}else if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("K")){%>Foto KTP <%}else if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("P")){%>Foto Properti<%}else{%>Bukti Transfer    <%}%>
							</h1>
						</div><!-- /.page-header -->

						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<form action="<%if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("AGEN")){%>agen.jsp<% }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("PEMILIK")){%>pemilik.jsp<%}else if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("P")){%>properti.jsp<% }else if(Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")){%>renovtransfer.jsp<% }else if(Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")){%>transfer.jsp<% }else if(Gen.gettable(request.getParameter("tp")).equalsIgnoreCase("PEMBAYARAN")){%>pembayaran.jsp<%}else{%>profile.jsp<%}%>?act=Upload&Y11=<%=request.getParameter("Y11")%>&tp=<%=Gen.gettable(request.getParameter("tp"))%>&fr=<%=Gen.gettable(request.getParameter("fr"))%>&S=<%=Gen.gettable(request.getParameter("S"))%><%if(Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")) out.print("&Y12="+request.getParameter("Y12")+"&Y13="+request.getParameter("Y13"));%><%if(Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")) out.print("&Y12="+request.getParameter("Y12")+"&Y13="+request.getParameter("Y13")+"&Y14="+request.getParameter("Y14"));%>" name="BGA" method="post" onsubmit="valid()" ENCTYPE="multipart/form-data">
											<div class="col-xs-12 col-sm-8">
												<div class="form-group">
													<label class="col-sm-3 control-label no-padding-right">
                                                    <%if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("G")){%>
                                                    Foto Anggota
                                                    <%}else if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("K")){%>
                                                    Foto KTP
                                                    <%}else if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("P")){%>
                                                    Foto Properti
                                                    <%}else{%>
                                                    Bukti Transfer
                                                    <%}%>
                                                    </label>

													<div class="col-sm-8">
                                                        <input type="file" name="file" id="id-input-file-2" />
													</div>
												</div>
                                            <%if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("T") && !Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")&& !Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")){%>
												<div class="space-4"></div>
												<div class="form-group">
													<label class="col-sm-3 control-label no-padding-right">*Tanggal Transfer</label>
													<div class="col-sm-9">
															<div class="input-medium">
																<div class="input-group">
        															<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.getToday("dd-MM-yyyy")%>" placeholder="dd-mm-yyyy" />
        															<span class="input-group-addon">
        																<i class="ace-icon fa fa-calendar"></i>
        															</span>
        													</div>
        												</div>                                                                    
													</div>
												</div>
												<div class="space-4"></div>
												<div class="form-group">
													<label class="col-sm-3 control-label no-padding-right">*Jumlah Transfer</label>
													<div class="col-sm-8">
																<input type="text" id="Y14" size="20" maxlength="20" name="Y14"  value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>" />
													</div>
												</div>
                                                <%}%>
												<div class="space-4"></div>
												<div class="form-group">
												<%if(!Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")&& !Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")){%>	<label class="col-sm-3 control-label no-padding-right">Catatan</label><%}else{%><label class="col-sm-3 control-label no-padding-right"> </label><%}%>
													<div class="col-sm-8">
                                                <%if(!Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")&& !Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")){%>
																<input type="text" id="S2" size="40" maxlength="60" name="Y13"  value="<%=Gen.gettable(request.getParameter("Y13")).trim()%>" />
                                                <%}%>
                              									<button class="btn btn-info" type="submit" >
                          											<i class="ace-icon fa fa-check bigger-110"></i>
                          											Kirim
                          										</button>															
													</div>
												</div>
                                            </div>
									</form>
								</div>

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
		<script src="assets/js/bootstrap-datepicker.min.js"></script>
        
		<!-- page specific plugin scripts -->
		<script src="assets/js/dropzone.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
				$('#id-input-file-2').ace_file_input({
					no_file:'No File ...',
					btn_choose:'Choose',
					btn_change:'Change',
					droppable:false,
					onchange:null,
					thumbnail:false //| true | large
					//whitelist:'gif|png|jpg|jpeg'
					//blacklist:'exe|php'
					//onchange:''
					//
				});
				$('.date-picker').datepicker({
					autoclose: true,
					todayHighlight: true
				})
				//show datepicker when clicking on the icon
				.next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
                function valid(){
 <%if(Gen.gettable(request.getParameter("fr")).equalsIgnoreCase("T") && !Gen.gettable(request.getParameter("tp")).startsWith("TRXPROP")&& !Gen.gettable(request.getParameter("tp")).startsWith("TRXRENOV")){%>
                    if(document.BGA.Y14.value=='' || document.BGA.Y14.value=='0'||document.BGA.Y14.value=='0.0'){
                        alert("Jumlah Transfer Tidak Valid");
                        return false;
                    }
                    if(document.BGA.Y12.value==''){
                        alert("Tanggal Transfer Tidak Valid");
                        return false;
                    }
 <%}%>
                    return true;
                }
		</script>
	</body>
</html>
