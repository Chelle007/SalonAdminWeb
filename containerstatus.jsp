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
         String title="Update Import Status";       
         String title1="DF=Discharged, FC=Full,  RE=Return";
         if(tp.startsWith("IMPSTS")){
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("1") ||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("2")||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("3")){
                String d=gen.gettable(request.getParameter("Dx"));
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("2"))d=gen.gettable(request.getParameter("Cx"));
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("3"))d=gen.gettable(request.getParameter("Rx")); 
                msg=sgen.update(conn,tp+Gen.gettable(request.getParameter("act")),new String[]{d,Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),tp+Gen.gettable(request.getParameter("act")),gen.gettable(request.getParameter("S3"))+"|"});
                if(msg.length()>0){
                    msg="(Update Data Failed!!"+msg+")";
                }else{
                    msg="(Update Data Successfully)";
                }     
            }
        }
        //System.out.println(tp+","+Gen.gettable(request.getParameter("act"))+","+Gen.gettable(request.getParameter("Dx"))+","+Gen.gettable(request.getParameter("S3"))+","+Gen.gettable(request.getParameter("S1")));
         if(tp.startsWith("EXPSTS")){
            title="Update Export Status";
            title1="ES=Empty, FL=Loading, OF=On Board, CP=Complete";       
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("1") ||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("2")||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("3")||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("4")||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("5")||Gen.gettable(request.getParameter("act")).equalsIgnoreCase("6")){
                String d=gen.gettable(request.getParameter("Dx"));
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("2"))d=gen.gettable(request.getParameter("Cx"));
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("3"))d=gen.gettable(request.getParameter("Rx")); 
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("4"))d=gen.gettable(request.getParameter("Ex")); 
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("6"))d=gen.gettable(request.getParameter("Sx")); 
                msg=sgen.update(conn,tp+Gen.gettable(request.getParameter("act")),new String[]{d,Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("4") && msg.length()==0){//update eta
                    msg=sgen.update(conn,tp+"5",new String[]{Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                }
                if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("3") && msg.length()==0){//update eta
                    msg=sgen.update(conn,tp+"4",new String[]{d,Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                    msg=sgen.update(conn,tp+"5",new String[]{Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                }
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),tp+Gen.gettable(request.getParameter("act")),gen.gettable(request.getParameter("S3"))+"|"});
                if(msg.length()>0){
                    msg="(Update Data Failed!!"+msg+")";
                }else{
                    msg="(Update Data Successfully)";
                }
     
                //System.out.println(tp+Gen.gettable(request.getParameter("act")));
            }
        }
        int CX=3;
         String[] judul=new String[]{"DATE","","CONTAINER NO","BL NO","IMPORT","SIZE","TYPE CODE","STS","DISCHARGE","COSIGNEE PICKUP","RETURN IN DEPOT"};
         if(tp.startsWith("EXPSTS")){
            judul=new String[]{"DATE","","CONT NO.","BL NO","EXPORT","SIZE","TYPE","STS","GET OUT","GET IN PORT","LOAD ON FEEDER","ETD BATAM"};
            CX=4;
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
          java.util.Vector combo2=sgen.getDataQuery(conn,"MOVEMENTYEAR",new String[0]);
          java.util.Vector status2=sgen.getDataQuery(conn,"STATUS2",new String[0]);
          java.util.Vector stx=sgen.getDataQuery(conn,"IMPORTSTS",new String[0]);
          if(tp.startsWith("EXPSTS")){
            stx=sgen.getDataQuery(conn,"EXPORTSTS",new String[0]);
          }   
            String f1=gen.gettable(request.getParameter("Y10"));
            String f2=gen.gettable(request.getParameter("Y11"));
            String tpx=tp;
            String sts=gen.gettable(request.getParameter("Y14")).trim();
            if(request.getParameter("Y10")==null ||f1.length()==0){
                if(combo1.size()>0){
                    f1=gen.getInt(gen.getToday("MM"))+"";
                }            
            }
            if(request.getParameter("Y11")==null ||f2.length()==0){
                if(combo2.size()>0) f2=gen.gettable(combo2.get(0));
            }
            cond=new String[]{f1,f2};
            if(gen.gettable(request.getParameter("Y15")).trim().length()>0){            
                tpx=tp+"5";
                cond=new String[]{gen.gettable(request.getParameter("Y15"))};
                f1="";
                f2="";            
            }else if(gen.gettable(request.getParameter("Y12")).length()>0 && gen.gettable(request.getParameter("Y13")).length()>0){
                tpx=tp+"3";
                cond=new String[]{gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0){
                tpx=tp+"1";
                cond=new String[]{gen.gettable(request.getParameter("Y12"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y13")).length()>0){
                tpx=tp+"2";
                cond=new String[]{gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }
        //    System.out.println(tpx);
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
       // System.out.println("job>>"+data.size()+","+f1+","+f2+",tpx="+tpx);     
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
                            <h1><%=title1%></h1>
						</div><!-- /.page-header -->
                        <form class="form-horizontal" name="BGA" method="POST" action="containerstatus.jsp?tp=<%=tp%>" >
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                						
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(f1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<select  name="Y11" onchange="refresh();"><option></option><%for(int m=0;m<combo2.size();m++){%><option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(f2.trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option><%}%></select>  </label>
											<label class="control-label">&nbsp;Start Date:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;End Date:<input class="input-medium date-picker" name="Y13"  id="Y13" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
                                            <label class="control-label">&nbsp;Status:<select name="Y15" onchange="refresh();"><option></option><%for(int m=0;m<stx.size();m++){%><option value="<%=gen.gettable(stx.get(m)).trim()%>" <%if(Gen.gettable(request.getParameter("Y15")).trim().equalsIgnoreCase(gen.gettable(stx.get(m)).trim())) out.print("selected");%>><%=gen.gettable(stx.get(m)).trim()%></option><%}%></select></label>
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
                                                            if(s==1)continue;
                                                            
                                                        %>         
														<th><%=judul[s]%></th>
                                                        <%}%>
    											</tr>
											</thead>

											<tbody>
												<tr>													
                                                        <%for(int s=0;s<judul.length-CX;s++){
                                                            if(s==1)continue;%>
														      <td></td>
                                                        <%}%>
                                                    <td><input class="input-medium date-picker" name="Dx" size="10" id="Dx" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Dx")).trim()%>" placeholder="dd-mm-yyyy"/></td>
                                                    <td><input class="input-medium date-picker" name="Cx" size="10"  id="Cx" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Cx")).trim()%>" placeholder="dd-mm-yyyy"/></td>
                                                    <td><input class="input-medium date-picker" name="Rx" size="10"  id="Rx" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Rx")).trim()%>" placeholder="dd-mm-yyyy"/></td>
                                                    <%if(tp.startsWith("EXPSTS")){%>
                                                    <td><input class="input-medium date-picker" name="Ex" size="10"  id="Ex" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Ex")).trim()%>" placeholder="dd-mm-yyyy"/></td>
                                                    <%}%>
    											</tr>
                                                   <%
                                                   int hic=1,cou=0;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(ss==1)continue;
                                                            cou++;
                                                       %>
                                                            <td nowrap>
                                                            <%if(ss==0){%>
                                                            <a href="javascript:jump('<%=gen.gettable(data.get(s+ss)).trim()%>','<%=gen.gettable(data.get(s+ss+1)).trim()%>','<%=gen.gettable(data.get(s+ss+2)).trim()%>')"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else if(ss==8 && gen.gettable(data.get(s+ss)).trim().length()==0){%>
                                                                <button onClick="javascript:onact('1','<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+ss-1)).trim()%>')"><img src="image/ok.gif" /></button>
                                                            <%}else if(ss==9 && gen.gettable(data.get(s+ss)).trim().length()==0){%>
                                                                <button onClick="javascript:onact('2','<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+ss-1)).trim()%>')"><img src="image/ok.gif" /></button>
                                                            <%}else if(ss==10 && gen.gettable(data.get(s+ss)).trim().length()==0){%>
                                                                <button onClick="javascript:onact('3','<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+ss-1)).trim()%>')"><img src="image/ok.gif" /></button>
                                                            <%}else if(ss==11 && gen.gettable(data.get(s+ss)).trim().length()==0){%>
                                                                <button onClick="javascript:onact('4','<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+ss-1)).trim()%>')"><img src="image/ok.gif" /></button>
                                                            <%}else if(ss==4 && gen.gettable(data.get(s+ss)).trim().length()==0){%>
                                                                <button onClick="javascript:onact('6','<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+ss-1)).trim()%>')"><img src="image/ok.gif" /></button>
                                                            <%}else{%>
                                                                 <%=gen.gettable(data.get(s+ss)).trim()%>
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
        	function jump(P1,P2,P3){
        		url="movementdetail.jsp?tp=MOVEMENTDETAIL&menu=false&canedit=true&S1="+P1+"&S2="+P2+"&S3="+P3;
        		window.open(url,"", "height=600,width=1400,resize=yes,toolbar=no,scrollbars=yes,menubar=no");
        	}
            function SetTime(trans,format){
               var y=m=d="";
               y=trans.charAt(6)+trans.charAt(7)+trans.charAt(8)+trans.charAt(9);
               if(format=="M"){
                  m=(trans.charAt(0)+trans.charAt(1))-1;
                  d=trans.charAt(3)+trans.charAt(4);
               }
               else {
                  d=trans.charAt(0)+trans.charAt(1);
                  m=(trans.charAt(3)+trans.charAt(4))-1;
               }
               var transdate = new Date(y,m,d);
               
               return transdate;
            }
            
            function onact(Parm,Parm1,Parm2,Parm3,Parm4){
                var a=true;               
                
                <%if(tp.startsWith("EXPSTS")){%>
                if(Parm=='1'){
                    if(document.BGA.Dx.value==''){
                        alert("Please Fill The Get Out Date");
                        a=false;
                    }
                }
                if(Parm=='2'){
                    if(document.BGA.Cx.value==''){
                        alert("Please Fill The Get In Port  Date");
                        a=false;
                    }

                  if(Parm4!="" && document.BGA.Cx.value!=""){
                       var aS = SetTime(Parm4,"D");
                       var bS = SetTime(document.BGA.Cx.value,"D");
                       if(aS>bS){
                            alert("Invalid Get In Port Date.Valid Input (Get In Port Date >= Get Out Date)");
                            a=false;
                       }
                  }
                }
                if(Parm=='3'){
                    if(document.BGA.Rx.value==''){
                        alert("Please Fill The Load On Feeder Date");
                        a=false;
                    }
                  if(Parm4!="" && document.BGA.Rx.value!=""){
                       var aS = SetTime(Parm4,"D");
                       var bS = SetTime(document.BGA.Rx.value,"D");
                       if(aS>bS){
                            alert("Invalid Load of Feeder Date.Valid Input (Load of Feeder Date >= Get In Port Date)");                            
                            a=false;
                       }
                  }
                }
                if(Parm=='4'){
                    if(document.BGA.Ex.value==''){
                        alert("Please Fill The ETD Batam Date");
                        a=false;
                    }
                  if(Parm4!="" && document.BGA.Ex.value!=""){
                       var aS = SetTime(Parm4,"D");
                       var bS = SetTime(document.BGA.Ex.value,"D");
                       if(aS>bS){
                            alert("Invalid ETD Batam Date.Valid Input (ETD Batam Date >= Load of Feeder Date)");
                            a=false;
                       }
                  }
                }
                if(Parm=='5'){
                    if(document.BGA.Ax.value==''){
                        alert("Please Fill The ETA Singapore Date");
                        a=false;
                    }
                }
                <%}else{%>
                if(Parm=='1'){
                    if(document.BGA.Dx.value==''){
                        alert("Please Fill The Discharge Date");
                        a=false;
                    }
                }
                if(Parm=='2'){
                    if(document.BGA.Cx.value==''){
                        alert("Please Fill The Cosignee Pickup Date");
                        a=false;
                    }
                  if(Parm4!='' && document.BGA.Cx.value!=''){
                       var disc = SetTime(Parm4,"D");
                       var pick = SetTime(document.BGA.Cx.value,"D");
                       if(disc>pick){
                            alert("Invalid Pickup Date. Valid Input (Pickup Date >= Discharge Date)");
                            a=false;
                       }
                  }
                }
                if(Parm=='3'){
                    if(document.BGA.Rx.value==''){
                        alert("Please Fill The Return In Depot Date");
                        a=false;
                    }
                  if(Parm4!='' && document.BGA.Rx.value!=''){
                       var pick = SetTime(Parm4,"D");
                       var ret = SetTime(document.BGA.Rx.value,"D");
                       if(pick>ret){
                            alert("Invalid Return In Depot Date.Valid (Input Return In Depot Date >= Pickup Date)");
                            a=false;
                       }
                  }
                }
                
                <%}%>
                if(a){
                <%if(tp.startsWith("EXPSTS")){%>
                        location.href="containerstatus.jsp?tp=<%=tp%>&act="+Parm+"&Ex="+document.BGA.Ex.value+"&Dx="+document.BGA.Dx.value+"&Rx="+document.BGA.Rx.value+"&Cx="+document.BGA.Cx.value+"&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y15="+document.BGA.Y15.value+"&S1="+Parm1+"&S2="+Parm2+"&S3="+Parm3;
                <%}else{%>
                        location.href="containerstatus.jsp?tp=<%=tp%>&act="+Parm+"&Dx="+document.BGA.Dx.value+"&Rx="+document.BGA.Rx.value+"&Cx="+document.BGA.Cx.value+"&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y15="+document.BGA.Y15.value+"&S1="+Parm1+"&S2="+Parm2+"&S3="+Parm3;
                <%}%>
               }
            }
            
		</script>
	</body>
</html>
