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
         String msg="";
         if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){         
            msg=sgen.update(conn,"SETORANDELETE",new String[]{gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))});
            java.util.Vector def=sgen.getDataQuery(conn,"DEFAULT",new String[0]);
            msg=sgen.update(conn,"HISTORYSETORAN5DELETE",new String[]{gen.gettable(request.getParameter("Y13")),"Bayar ke "+gen.gettable(def.get(0)).trim()});
            msg=sgen.update(conn,"LOGMENUADD",new String[]{sgen.getUserId(vk),"SETORANDELETE"});
         }
         String[] cond=new String[0] ;
          String title="Pembayaran by Siswa";       
          String[] judul=new String[]{"Id Siswa","Nama","Tahun Ajaran","Semester","Jumlah Bantuan GPP"};  
          String[] juduldetail=new String[]{"","","","","Tanggal","Jumlah Bantuan GPP"};  
          if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANGPP")){
            judul=new String[]{"Tahun Ajaran","Semester","Tanggal Setor","Jumlah Bantuan"};
            juduldetail=new String[]{"Id Siswa","Nama","","","","Kelas","SPP","Jumlah Bantuan"};    
            title="Setoran ke Yayasan";
          }else if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANTHN")){
            judul=new String[]{"Tahun Ajaran","Jumlah Bantuan"};  
            juduldetail=new String[]{"","","Tanggal Setor","Jumlah Bantuan"};    
            title="Pembayaran Tahunan";          
          }
          
        java.util.Vector data=sgen.getDataQuery(conn,tp,cond);
        java.util.Vector datadetail=sgen.getDataQuery(conn,tp+"DETAIL",cond);          
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
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>
													<th class="detail-col">Details</th>
                                                        <%for(int s=0;s<judul.length;s++){
                                                        if(judul[s].length()==0) continue;
                                                        %>         
														<th><%=judul[s]%></th>
                                                        <%}%>
                                                        <%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANGPP")){%>
                                                            
													       <%if(sgen.getUserType(vk).equalsIgnoreCase("A")){%><th><button class="btn btn-info" type="button" onclick="onact();">
															     <i class="ace-icon fa fa-plus-circle bigger-110"></i>
                                                                
														        </button></th>
                                                            <%}%>
                                                        <%}%>
												</tr>
											</thead>

											<tbody>
                                                   <%for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
													<td class="center">
														<div class="action-buttons">
															<a href="#" class="green bigger-140 show-details-btn" title="Show Details">
																<i class="ace-icon fa fa-angle-double-down"></i>
																<span class="sr-only">Details</span>
															</a>
														</div>
													</td>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                       if(judul[ss].length()==0) continue;
                                                       %>         
														<td><%=gen.gettable(data.get(s+ss))%></td>
                                                        <%}%>
                                                        <%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANGPP")){%>
                                                            <%if(sgen.getUserType(vk).equalsIgnoreCase("A")){%>
          													<td>
          														<div class="hidden-sm hidden-xs btn-group">
          															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>')">
          																<i class="ace-icon fa fa-trash-o bigger-120"></i>
          															</button>
          
          														</div>
          
          													</td>
                                                            <%}%>
                                                        <%}%>
												</tr>
												<tr class="detail-row">
													<td colspan="3">
              											<table id="dynamic-table" class="table table-striped table-bordered table-hover">
              												<thead>
              													<tr>
                                                                      <%for(int sy=0;sy<juduldetail.length;sy++){
                                                                            if(juduldetail[sy].length()==0)continue;
                                                                      %>         
              														<th><%=juduldetail[sy]%></th>
                                                                      <%}%>
              													</tr>
              												</thead>
              
              												<tbody>
                                                                 <%for(int sy=0;sy<datadetail.size();sy+=juduldetail.length){
                                                                        if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORAN")){
                                                                            if(gen.gettable(datadetail.get(2+sy)).trim().equalsIgnoreCase(gen.gettable(data.get(2+s)).trim()) && gen.gettable(datadetail.get(sy)).trim().equalsIgnoreCase(gen.gettable(data.get(s)).trim()) && gen.gettable(datadetail.get(3+sy)).trim().equalsIgnoreCase(gen.gettable(data.get(3+s)).trim())){                                                                            
                                                                            }else{continue;}
                                                                        }
                                                                        if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANGPP")){
                                                                            if(gen.gettable(datadetail.get(2+sy)).trim().equalsIgnoreCase(gen.gettable(data.get(s)).trim()) && gen.gettable(datadetail.get(3+sy)).trim().equalsIgnoreCase(gen.gettable(data.get(1+s)).trim()) && gen.gettable(datadetail.get(4+sy)).trim().equalsIgnoreCase(gen.gettable(data.get(2+s)).trim())){                                                                            
                                                                            }else{continue;}
                                                                        }
                                                                        if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SETORANTHN")){
                                                                            if(gen.gettable(datadetail.get(sy)).trim().equalsIgnoreCase(gen.gettable(data.get(s)).trim())){                                                                            
                                                                            }else{continue;}
                                                                        }
                                                                 %>         
              													<tr>
                                                                     <%for(int ss=0;ss<juduldetail.length;ss++){
                                                                            if(juduldetail[ss].length()==0)continue;
                                                                     %>         														
                                                                          <%if(juduldetail[ss].startsWith("Jumlah")||juduldetail[ss].startsWith("Bantuan")||juduldetail[ss].startsWith("SPP")){%>
                                                                          <td align=right><%=gen.getNumberFormat(datadetail.get(sy+ss),0)%></td>
                                                                          <%}else{%>
                                                                          <td><%=gen.gettable(datadetail.get(sy+ss)).trim()%></td>
                                                                          <%}%>
                                                                      <%}%>
              													</tr>
                                                                  <%}%>
              												</tbody>
              											</table>
													</td>
												</tr>
                                                    <%}%>
											</tbody>
										</table>
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
            function ondel(Parm,Parm2,Parm3){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="setoran.jsp?act=DEL&tp=<%=request.getParameter("tp")%>&Y11="+Parm+"&Y12="+Parm2+"&Y13="+Parm3;
                }
            }
            function  refresh(){
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            
            function onact(){
                location.href="formsetoran.jsp";
            }
		</script>
	</body>
</html>
