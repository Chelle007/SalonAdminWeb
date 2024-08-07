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
        
         String[] judul=new String[]{"STATUS","DEPO","SIZE","TYPE CODE","STS CONTAINER","COUNT CONTAINER"};
         
          String title="List of Movement";       
          String[] cond=new String[0];
          java.util.Vector tmp=new java.util.Vector();
          String tpx=tp;
          if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("E")) tpx=tp+"2";
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
        java.util.Vector datadetail=sgen.getDataQuery(conn,tpx+"DETAIL",cond);
          for(int m=0;m<data.size();m+=6){
            boolean can1=false,can2=false,can3=false,can4=false;
            if(gen.gettable(request.getParameter("Y10")).length()==0 || gen.gettable(request.getParameter("Y10")).equalsIgnoreCase(gen.gettable(data.get(m+1)).trim())){
                can1=true;
            }
            if(gen.gettable(request.getParameter("Y11")).length()==0 || gen.gettable(request.getParameter("Y11")).equalsIgnoreCase(gen.gettable(data.get(m+2)).trim())){
                can2=true;
            }
            if(gen.gettable(request.getParameter("Y12")).length()==0 || gen.gettable(request.getParameter("Y12")).equalsIgnoreCase(gen.gettable(data.get(m+3)).trim())){
                can3=true;
            }
            if(gen.gettable(request.getParameter("Y13")).length()==0 || gen.gettable(request.getParameter("Y13")).equalsIgnoreCase(gen.gettable(data.get(m+4)).trim())){
                can4=true;
            }
            if(can1 && can2&& can3&&can4){
                for(int mx=0;mx<6;mx++)tmp.addElement(data.get(m+mx));
            }
            
          }
          data=tmp;
         // System.out.println(gen.gettable(request.getParameter("Y1"))+","+gen.gettable(request.getParameter("Y10"))+","+gen.gettable(request.getParameter("Y11")));
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
                       <form class="form-horizontal" name="BGA" method="POST" action="updstatusmove.jsp?tp=<%=tp%>" >                						
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
    										<label class="control-label">Movement:<select  name="Y1" onchange="refresh();">
                                            <option value="I">Import</option>
                                            <option value="E" <%if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("E")) out.print("selected");%>>Export</option>
                                            </select>  </label>
    										<label class="control-label">Depo:<select  name="Y10" onchange="refresh();">
                                            <option></option>
                                            <option value="B" <%if(gen.gettable(request.getParameter("Y10")).equalsIgnoreCase("B")) out.print("selected");%>>B</option>
                                            <option value="W" <%if(gen.gettable(request.getParameter("Y10")).equalsIgnoreCase("W")) out.print("selected");%>>W</option>
                                            </select>  </label>
                                            <label class="control-label">&nbsp;Size:<select name="Y11" onchange="refresh();">
                                            <option></option>
                                            <option value="20" <%if(gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("20")) out.print("selected");%>>20</option>
                                            <option value="40" <%if(gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("40")) out.print("selected");%>>40</option>
                                            </select></label>
                                            <label class="control-label">&nbsp;Type Code:<select name="Y12" onchange="refresh();">
                                            <option></option>
                                            <option value="FR" <%if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("FR")) out.print("selected");%>>FR</option>
                                            <option value="GP" <%if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("GP")) out.print("selected");%>>GP</option>
                                            <option value="HQ" <%if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("HQ")) out.print("selected");%>>HQ</option>
                                            <option value="OT" <%if(gen.gettable(request.getParameter("Y12")).equalsIgnoreCase("OT")) out.print("selected");%>>OT</option>
                                            </select></label>
                                            <label class="control-label">&nbsp;Status:<select name="Y13" onchange="refresh();">
                                            <option></option>
                                            <%if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("E")){%>
                                            <option value="ES" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("ES")) out.print("selected");%>>ES</option>
                                            <option value="TE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("TE")) out.print("selected");%>>TE</option>
                                            <option value="FL" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("FL")) out.print("selected");%>>FL</option>
                                            <option value="RE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("RE")) out.print("selected");%>>RE</option>
                                            <option value="OF" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("OF")) out.print("selected");%>>OF</option>
                                            <option value="OE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("OE")) out.print("selected");%>>OE</option>
                                            <%}else{%>
                                            <option value="DF" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("DF")) out.print("selected");%>>DF</option>
                                            <option value="DE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("DE")) out.print("selected");%>>DE</option>
                                            <option value="FC" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("FC")) out.print("selected");%>>FC</option>
                                            <option value="TE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("TE")) out.print("selected");%>>TE</option>
                                            <option value="RE" <%if(gen.gettable(request.getParameter("Y13")).equalsIgnoreCase("RE")) out.print("selected");%>>RE</option>
                                            <%}%>
                                            </select></label>
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
                                                        <%for(int s=0;s<judul.length;s++){%>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%}%>
                                                        <td class="detail-col"><b>Details</td>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												     <tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){                                                            
                                                       %>
                                                            <td nowrap>
                                                            <%if(ss==4){%>
                                                            <a href="updstatusdetail.jsp?tp=UPDSTSMOVE&Y1=<%=gen.gettable(request.getParameter("Y1"))%>&Y10=<%=gen.gettable(request.getParameter("Y10"))%>&Y11=<%=gen.gettable(request.getParameter("Y11"))%>&Y12=<%=gen.gettable(request.getParameter("Y12"))%>&Y13=<%=gen.gettable(request.getParameter("Y13"))%>&S1=<%=gen.gettable(data.get(s)).trim()%>&S2=<%=gen.gettable(data.get(s+1)).trim()%>&S3=<%=gen.gettable(data.get(s+2)).trim()%>&S4=<%=gen.gettable(data.get(s+3)).trim()%>&S5=<%=gen.gettable(data.get(s+4)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{%>
                                                                 <%=gen.gettable(data.get(s+ss)).trim()%>
                                                            <%}%>
                                                            </td>
                                                        <%}%>
  													<td class="center">
  														<div class="action-buttons">
  															<a href="#" class="green bigger-140 show-details-btn" title="Show Details">
  																<i class="ace-icon fa fa-angle-double-down"></i>
  																<span class="sr-only">Details</span>
  															</a>
  														</div>
  													</td>                                                        
												  </tr>
  												  <tr class="detail-row">
  													<td colspan="6" align=right>
                    											<table id="c-table" class="table table-striped table-bordered table-hover">
                      												<thead>
                      													<tr> 
                                                                              <td  align=center><b>Container No.</td>
                                                                              <%if(!gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("E")){%>
                                                                              <td align=center><b>Discharge Date</td>
                                                                              <td align=center><b>Cosignee Pickup Date</td>
                                                                              <td align=center><b>Return In Depot</td>
                                                                              <%}else{%>
                                                                              <td align=center><b>Get Out Date</td>
                                                                              <td align=center><b>Get In Port Date</td>
                                                                              <td align=center><b>Load On Feeder</td>
                                                                              <%}%>
                                                                              <td align=center><b>Free Time</td>
                                                                        </tr>
                                                                    </thead>
                    												<tbody>
                                                                      <%for(int ii=0;ii<datadetail.size();ii+=10){
                                                                        
                                                                        if(Gen.gettable(data.get(s)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii)).trim()) && Gen.gettable(data.get(s+1)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii+1)).trim()) 
                                                                        && Gen.gettable(data.get(s+2)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii+2)).trim())&& Gen.gettable(data.get(s+3)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii+3)).trim())
                                                                        && Gen.gettable(data.get(s+4)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii+4)).trim())){
                                                                            String ket="";
                                                                            int h=0;
                                                                            //if(Gen.gettable(datadetail.get(ii+9)).length()>0){
                                                                              //  h=gen.getInt(gen.getHYFFormat(Gen.gettable(datadetail.get(ii+9)),"dd-MM-yyyy"))-gen.getInt(gen.getHYFFormat(Gen.gettable(datadetail.get(ii+7)),"dd-MM-yyyy"));
                                                                            //}else if (Gen.gettable(datadetail.get(ii+7)).length()>0){
                                                                              //  h=gen.getInt(gen.getHYFToday())-gen.getInt(gen.getHYFFormat(Gen.gettable(datadetail.get(ii+7)),"dd-MM-yyyy"));
                                                                            //}
                                                                            h=gen.getInt(datadetail.get(ii+6));//-h;
                                                                        %>
                                                  						<tr>
                                                  							<td nowrap><%=Gen.gettable(datadetail.get(ii+5)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+7)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+8)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+9)).trim()%></td>
                                                                            <td nowrap><%if(h<0)out.print("<font color=red>");%><%=(""+h)%></td>
                                                      						</tr>
                                                                        <%}
                                                                        }%>    
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
                       </form>
                        
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
            
		</script>
	</body>
</html>
