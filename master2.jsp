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
	   <jsp:include page="login.jsp" flush ="true"/>
<%
   }else{
    com.ysoft.General gen = new com.ysoft.General();
    com.ysoft.General Gen = new com.ysoft.General();
    com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
    String tp=gen.gettable(request.getParameter("tp"));
    String title=gen.gettable(request.getParameter("title"));
    com.ysoft.convertxml convert = new com.ysoft.convertxml();
    com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
    java.sql.Connection conn = connMgr.getConnection("db2");
    java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
    com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
    String msg="";

    String[] judul = null;
    String[] deleteSql = null;
    // ubah sini
    if ("S_CARDS".equals(tp)) {
        judul = new String[]{"C_ID", "Card_name", "Category", "Card_value", "Payment_grace_period", "Due_date_type"};
        deleteSql = new String[]{"S_CARDSDELETE", "S_CARD_ALLOWED_ITEMDELETE", "S_CARD_ALLOWED_TREATMENTDELETE"};
    } else if ("S_CARD_PACKAGE".equals(tp)) {
        judul = new String[]{"CP_ID", "Descriptions", "Member_category", "Price"};
        deleteSql = new String[]{"S_CARD_PACKAGEDELETE", "S_CARD_PACKAGE_DETAILDELETE"};
    } else if ("S_TREATMENT".equals(tp)) {
        judul = new String[]{"T_ID", "Treatment_name"};
        deleteSql = new String[]{"S_TREATMENTDELETE", "S_TREATMENT_ITEMSDELETE"};
    }

    if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){
        conn.setAutoCommit(false);

        if(msg.length()==0) {
            for (int i=0; i<deleteSql.length; i++) {
                msg=sgen.update(conn,deleteSql[i],new String[]{Gen.gettable(request.getParameter("S1"))});
            }
            msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),deleteSql[0],gen.gettable(request.getParameter("S1"))+"|"});
        }

        if(msg.length()>0){
            conn.rollback();
            msg="(Delete Data Failed!!"+msg+")";
        }else{
            conn.commit();
            msg="(Delete Data Successfully)";
        }

        conn.setAutoCommit(true);
    }

    String[] cond=new String[0];
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
    String f1=gen.gettable(request.getParameter("Y10"));
    if(request.getParameter("Y10")==null){
         f1=gen.getInt(gen.getToday("MM"))+"";
    }
    String f2=gen.gettable(request.getParameter("Y11"));
    if(f2.length()==0)f2=gen.getToday("yyyy");
    cond=new String[]{f1,f2};
    String tpx="SALESLIST1";
    if (gen.gettable(request.getParameter("ST1")).length()>0){
        tpx="SALESLIST7";
        cond=new String[]{"%"+gen.gettable(request.getParameter("ST1"))+"%"};
        f1="";
        f2="";
    }else if (gen.gettable(request.getParameter("ST2")).length()>0){
        tpx="SALESLIST8";
        cond=new String[]{"%"+gen.gettable(request.getParameter("ST2"))+"%"};
        f1="";
        f2="";
    }else if (gen.gettable(request.getParameter("Y15")).length()>0){
        tpx="SALESLIST5";
        cond=new String[]{gen.gettable(request.getParameter("Y15"))};
        f1="";
        f2="";
    }else if (gen.gettable(request.getParameter("Y14")).length()>0){
        tpx="SALESLIST6";
        cond=new String[]{gen.gettable(request.getParameter("Y14"))};
        f1="";
        f2="";
    }else if(gen.gettable(request.getParameter("Y12")).length()>0 && gen.gettable(request.getParameter("Y13")).length()>0){
        tpx="SALESLIST4";
        cond=new String[]{gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))};
        f1="";
        f2="";
    }else if(gen.gettable(request.getParameter("Y12")).length()>0){
        tpx="SALESLIST2";
        cond=new String[]{gen.gettable(request.getParameter("Y12"))};
        f1="";
        f2="";
    }else if(gen.gettable(request.getParameter("Y13")).length()>0){
        tpx="SALESLIST3";
        cond=new String[]{gen.gettable(request.getParameter("Y13"))};
        f1="";
        f2="";
    }
    java.util.Vector data=sgen.getDataQuery(conn,tp,new String[0]);
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
                                                        <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;<%if(s==0){%><a href="master2detail_<%=tp%>.jsp?add=true&tp=<%=tp%>&title=<%=title%>"><img width=20 height=20 src=image/plus.gif></a><%}%></th>
                                                        <%}%>
                                                    <th>DELETE</th>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                       %>
                                                            <td <%if(ss>=6) out.print("align=right");%>>
                                                            <%if(ss==0){%>
                                                            <a href="master2detail_<%=tp%>.jsp?tp=<%=tp%>&title=<%=title%>&canedit=true&S1=<%=gen.gettable(data.get(s+ss)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<6){
                                                                 out.print(gen.gettable(data.get(s+ss)).trim());
                                                                }else{
                                                                 out.print(gen.getNumberFormat(data.get(s+ss),0));
                                                                }
                                                            %>
                                                            
                                                            <%}%>
                                                            </td>
                                                        <%}%>
  													<td>
  														<div class="hidden-sm hidden-xs btn-group">
  															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s)).trim()%>')">
  																<i class="ace-icon fa fa-trash-o bigger-120"></i>
  															</button>
  														</div>                        
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
            function  refresh(){
                      BGA.submit();
            }
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            function ondel(Parm){
                if(confirm("Delete Selected Record?")){
                    location.href="master2.jsp?act=DEL&tp=<%=request.getParameter("tp")%>&title=<%=title%>&S1="+Parm;
                }
            }
            function upload(){
        		location.href="upload.jsp?tp=UPLOADJOB";
        	}
            
		</script>
	</body>
	<%}%>
</html>
