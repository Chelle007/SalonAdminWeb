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
         String[] judul=new String[]{"DATE","SEQ","CONTAINER NO","BL NO","IMPORT","FEEDER VOYAGE","SIZE","TYPE CODE","COSIGNEE","STS","SHIPPER","ON BOARD","EXPORT"};
         
          String title="List of Container ";
          String title2=gen.gettable(request.getParameter("S1"))+", Year="+gen.gettable(request.getParameter("S5"))+", Week="+gen.gettable(request.getParameter("S4"))+", Size="+gen.gettable(request.getParameter("S3"))+" Type="+gen.gettable(request.getParameter("S2"));
          String[] x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5"))};
          if(tp.equalsIgnoreCase("CONTAINER3") ||tp.equalsIgnoreCase("CONTAINER4")){
                title2=gen.gettable(request.getParameter("S1"))+", Depo="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S3"))+", Size="+gen.gettable(request.getParameter("S4"))+", Current Status="+gen.gettable(request.getParameter("S5"));
          }       
          if(tp.equalsIgnoreCase("CONTAINER12") ||tp.equalsIgnoreCase("CONTAINER14") ||tp.equalsIgnoreCase("CONTAINER5")){
                title2=gen.gettable(request.getParameter("S1"))+", Status="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S4"))+", Size="+gen.gettable(request.getParameter("S3"))+", Month-Year="+gen.gettable(request.getParameter("S5"))+"-"+gen.gettable(request.getParameter("S6"))+",Depo="+gen.gettable(request.getParameter("S7"));
          }       
          if(tp.equalsIgnoreCase("CONTAINER13") ||tp.equalsIgnoreCase("CONTAINER15") ||tp.equalsIgnoreCase("CONTAINER6")){
                title2=gen.gettable(request.getParameter("S1"))+", Status="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S4"))+", Size="+gen.gettable(request.getParameter("S3"))+", Week-Year="+gen.gettable(request.getParameter("S5"))+"-"+gen.gettable(request.getParameter("S6"))+",Depo="+gen.gettable(request.getParameter("S7"));
          }
          if(tp.equalsIgnoreCase("CONTAINER8")||tp.equalsIgnoreCase("CONTAINER9")){//dari movement of chart
                title2=gen.gettable(request.getParameter("S1"))+", Size="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S3"))+", Month-Year="+gen.gettable(request.getParameter("S4"))+"-"+gen.gettable(request.getParameter("S5"));
          }
          if(tp.equalsIgnoreCase("CONTAINER10")||tp.equalsIgnoreCase("CONTAINER11")){//dari movement of chart
                title2=gen.gettable(request.getParameter("S1"))+", Size="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S3"))+", Week-Year="+gen.gettable(request.getParameter("S4"))+"-"+gen.gettable(request.getParameter("S5"));
          }
          if(tp.equalsIgnoreCase("CONTAINER5") ||tp.equalsIgnoreCase("CONTAINER6")){
            x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S7")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S7"))};
          }else if(tp.equalsIgnoreCase("CONTAINER15") ||tp.equalsIgnoreCase("CONTAINER12")||tp.equalsIgnoreCase("CONTAINER13") ||tp.equalsIgnoreCase("CONTAINER14")){
            x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S7"))};
          }else if(tp.equalsIgnoreCase("CONTAINER18") ||tp.equalsIgnoreCase("CONTAINER19")){
            if(tp.equalsIgnoreCase("CONTAINER18")){
                title2=gen.gettable(request.getParameter("S1"))+", Code/DeptCode="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S4"))+", Size="+gen.gettable(request.getParameter("S3"))+", Month-Year="+gen.gettable(request.getParameter("S5"))+"-"+gen.gettable(request.getParameter("S6"))+",Depo="+gen.gettable(request.getParameter("S7"));
            }else{
                title2=gen.gettable(request.getParameter("S1"))+", Code/DeptCode="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S4"))+", Size="+gen.gettable(request.getParameter("S3"))+", Week-Year="+gen.gettable(request.getParameter("S5"))+"-"+gen.gettable(request.getParameter("S6"))+",Depo="+gen.gettable(request.getParameter("S7"));
            }
            x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S7")),gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),gen.gettable(request.getParameter("S6")),gen.gettable(request.getParameter("S7"))};
          }       
          String tpx=tp;
          if(tp.equalsIgnoreCase("CONTAINER16") ||tp.equalsIgnoreCase("CONTAINER17")){
                title2=gen.gettable(request.getParameter("S1"))+", Depo="+gen.gettable(request.getParameter("S2"))+", Type="+gen.gettable(request.getParameter("S3"))+", Size="+gen.gettable(request.getParameter("S4"))+", Current Status="+gen.gettable(request.getParameter("S5"));
                String st=gen.gettable(request.getParameter("S6"));
                String end=gen.gettable(request.getParameter("S7"));
                if(st.length()>0 && end.length()>0){
                    tpx=tpx+"3";
                    x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),st,end};
                    title2=title2+"("+st+"/"+end+")";
                }else if(st.length()>0){
                    tpx=tpx+"1";
                    x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),st};
                    title2=title2+"("+st+")";
                }else if(end.length()>0){
                    tpx=tpx+"2";
                    x=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S3")),gen.gettable(request.getParameter("S4")),gen.gettable(request.getParameter("S5")),end};
                    title2=title2+"("+end+")";
                }             
          }       
        java.util.Vector data=sgen.getDataQuery(conn,tpx,x);
        java.util.Vector tmpdata=new java.util.Vector();
        //System.out.println(data.size()+","+java.util.Arrays.toString(x));
        int hit=1;
        for(int m=0;m<data.size();m+=13){
            for(int mm=0;mm<13;mm++){
                if(mm==1)tmpdata.addElement(hit+"");
                else tmpdata.addElement(data.get(m+mm));
            }
            hit++;
        }
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  java.util.Vector judulx=gen.getElement(',',"DATE,[SEQ] ,[CONTAINER NO],[BL NO],[STATUS],[FEEDER VOYAGE] ,[SIZE],[TYPE CODE],[COSIGNEE] ,[STS],[SHIPPER],ON BOARD DATE,STATUS2,PICKUP COSIGNEE DATE,RETURN IN DEPO DATE,GET IN DATE,GET OUT DATE,LOAD ON FEEDER DATE,ETD BATAM DATE,ETA SG DATE,CONDITION,");
                  java.util.Vector datat=sgen.getDataQuery(conn,"EXCEL"+tpx,x);
                  java.util.Vector tmpdatat=new java.util.Vector();
                  //System.out.println(data.size()+","+java.util.Arrays.toString(x));
                  hit=1;
                  for(int m=0;m<datat.size();m+=21){
                      for(int mm=0;mm<21;mm++){
                          if(mm==1)tmpdatat.addElement(hit+"");
                          else tmpdatat.addElement(datat.get(m+mm));
                      }
                      hit++;
                  }
                  ses.setAttribute("DATAXLS",tmpdatat);
                  ses.setAttribute("JUDULXLS",judulx);
                  ses.setAttribute("NUMBERXLS",new java.util.Vector());
                  bd.doAll(request);
            }            
        
    //    System.out.println("tp>>"+tp+",datasize="+tmpdata.size());     
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin"  <%if(gen.gettable(request.getParameter("tpx")).startsWith("Download")){%> onload="pop()"<%}%>>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%>&nbsp;&nbsp;&nbsp;<a href="javascript:down()"><img width=30 height=30 src=image/download.jfif ></a></h1>
							<h1><%=title2%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>													
                                                        <%for(int s=0;s<judul.length;s++){
                                                        %>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%}%>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                       %>
                                                            <td  nowrap>
                                                            <%if(ss==2){%>
                                                                <a href="javascript:entry('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>')"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{%>
                                                                 <%=gen.gettable(tmpdata.get(s+ss)).trim()%>
                                                            <%}%>
                                                            </td>
                                                        <%}%>
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
            function down(){
                 location.href="movementc.jsp?tb=ListContainer&tp=<%=tp%>&tpx=Download&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>&S3=<%=gen.gettable(request.getParameter("S3"))%>&S4=<%=gen.gettable(request.getParameter("S4"))%>&S5=<%=gen.gettable(request.getParameter("S5"))%>&S6=<%=gen.gettable(request.getParameter("S6"))%>&S7=<%=gen.gettable(request.getParameter("S7"))%>";
            }
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
        	function entry (Parm1,Parm2,Parm3){
        		window.open("movementdetail.jsp?tp=MOVEMENTDETAIL&menu=false&canedit=true&S1="+Parm1+"&S2="+Parm2+"&S3="+Parm3,"","height=600,width=1400,toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            
            function ondel(Parm,Parm1,Parm2){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="movement.jsp?act=DEL&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y14="+document.BGA.Y14.value+"&tp=<%=request.getParameter("tp")%>&S1="+Parm+"&S2="+Parm1+"&S3="+Parm2;
                }
            }
            
		</script>
	</body>
</html>
