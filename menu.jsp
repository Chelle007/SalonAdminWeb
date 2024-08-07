<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}                    

      com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
      com.ysoft.General gen = new com.ysoft.General();  
     //System.out.println("level>"+gen.gettable(ses.getAttribute("TxtLevel")).trim());
%>
	<div id="navbar" class="navbar navbar-default          ace-save-state">
		<div class="navbar-container ace-save-state" id="navbar-container">
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
					<span class="sr-only">Toggle sidebar</span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>
				</button>
			<div class="navbar-header pull-left">
					<span  class="navbar-brand"><small>
						<img width=20% height=20% src=image/logo.png >						
					</small>
                      </span>
			</div>
			<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<span  class="navbar-brand">
            				<small><%=gen.gettable(ses.getAttribute("TxtName"))%></small>
                        	<span class="btn btn-sm" data-rel="tooltip" title="Logout"><a href="Logout.jsp">Logout</a> </span>
                      </span>                                    
			</div>
		</div><!-- /.navbar-container -->
	</div>

		<div class="main-container ace-save-state" id="main-container">
			<script type="text/javascript">
				try{ace.settings.loadState('main-container')}catch(e){}
			</script>

			<div id="sidebar" class="sidebar                  responsive                    ace-save-state">
				<script type="text/javascript">
					try{ace.settings.loadState('sidebar')}catch(e){}
				</script>


				<ul class="nav nav-list">
					<li class="<%if(request.getParameter("tp")==null){%>active<%}%>">
						<a href="profile.jsp">
							<i class="menu-icon fa fa-user"></i>
							<span class="menu-text">Profile</span>
						</a>

						<b class="arrow"></b>
					</li>
                    <%if(gen.gettable(ses.getAttribute("TxtLevel")).trim().equalsIgnoreCase("1")){%>
					<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("P_")){%>active open<%}%>">
						<a href="#" class="dropdown-toggle">
							<i class="menu-icon fa fa-users"></i>
							<span class="menu-text">People</span>

							<b class="arrow fa fa-angle-down"></b>
						</a>

						<b class="arrow"></b>
						<ul class="submenu">
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("P_EMPLOYEE")){%>active<%}%>">
								<a href="master1.jsp?tp=P_EMPLOYEE&title=Employee">
									<i class="menu-icon fa fa-caret-right"></i>
							Employee
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("P_MEMBER")){%>active<%}%>">
								<a href="master1.jsp?tp=P_MEMBER&title=Member">
									<i class="menu-icon fa fa-caret-right"></i>
							Member
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("P_SUPPLIER")){%>active<%}%>">
								<a href="master1.jsp?tp=P_SUPPLIER&title=Supplier">
									<i class="menu-icon fa fa-caret-right"></i>
							Supplier
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("P_AGENT")){%>active<%}%>">
								<a href="master1.jsp?tp=P_AGENT&title=Agent">
									<i class="menu-icon fa fa-caret-right"></i>
								Agent
								</a>
								<b class="arrow"></b>
							</li>
                        </ul>
					</li>

					<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("S_")){%>active open<%}%>">
                        <a href="#" class="dropdown-toggle">
                            <i class="menu-icon fa fa-pencil-square-o"></i>
                            <span class="menu-text">Setting</span>

                            <b class="arrow fa fa-angle-down"></b>
                        </a>

                        <b class="arrow"></b>
                        <ul class="submenu">
                            <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_BANK")){%>active<%}%>">
                                <a href="master1.jsp?tp=S_BANK&title=Bank">
                                    <i class="menu-icon fa fa-caret-right"></i>
                                Bank
                                </a>
                                <b class="arrow"></b>
                            </li>
                            <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_ITEM")){%>active<%}%>">
                                <a href="master1.jsp?tp=S_ITEM&title=Item">
                                    <i class="menu-icon fa fa-caret-right"></i>
                                Item
                                </a>
                                <b class="arrow"></b>
                            </li>
                            <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_CARDS")){%>active<%}%>">
                                <a href="master2.jsp?tp=S_CARDS&title=Card">
                                    <i class="menu-icon fa fa-caret-right"></i>
                                Card
                                </a>
                                <b class="arrow"></b>
                            </li>
                            <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_CARD_PACKAGE")){%>active<%}%>">
                                <a href="master2.jsp?tp=S_CARD_PACKAGE&title=CardPackage">
                                    <i class="menu-icon fa fa-caret-right"></i>
                                Card Package
                                </a>
                                <b class="arrow"></b>
                            </li>
                            <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_TREATMENT")){%>active<%}%>">
                                <a href="master2.jsp?tp=S_TREATMENT&title=Treatment">
                                    <i class="menu-icon fa fa-caret-right"></i>
                                Treatment
                                </a>
                                <b class="arrow"></b>
                            </li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("S_ACCOUNT")){%>active<%}%>">
								<a href="account.jsp?tp=S_ACCOUNT&title=Account">
									<i class="menu-icon fa fa-caret-right"></i>
								Account
								</a>
								<b class="arrow"></b>
							</li>
                        </ul>
                    </li>
                    <%}%>
					<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("CASHIER")||gen.gettable(request.getParameter("from")).equalsIgnoreCase("CASHIER")){%>active<%}%>">
						<a href="cashier.jsp?tp=CASHIER">
							<i class="menu-icon   fa fa-money"></i>
							<span class="menu-text">Cashier</span>
						</a>
						<b class="arrow"></b>
					</li>
                   <%if(gen.gettable(ses.getAttribute("TxtLevel")).trim().equalsIgnoreCase("1")){%>
					<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("SALES") && !gen.gettable(request.getParameter("from")).equalsIgnoreCase("CASHIER")){%>active<%}%>">
						<a href="sales.jsp?tp=SALES">
							<i class="menu-icon   fa fa-tasks"></i>
							<span class="menu-text">Sales</span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("TREATMENT") && !gen.gettable(request.getParameter("from")).equalsIgnoreCase("CASHIER")){%>active<%}%>">
						<a href="treatment.jsp?tp=TREATMENT">
							<i class="menu-icon   fa fa-credit-card"></i>
							<span class="menu-text">Treatment</span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("PURCHASE")){%>active<%}%>">
						<a href="purchase.jsp?tp=PURCHASE">
							<i class="menu-icon  fa fa-tachometer"></i>
							<span class="menu-text">Purchase</span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("TRXBANK")){%>active<%}%>">
						<a href="banktransaction.jsp?tp=TRXBANK">
							<i class="menu-icon fa fa-signal"></i>
							<span class="menu-text">Bank/Cash</span>
						</a>
						<b class="arrow"></b>
					</li>                   
					<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("REP")){%>active open<%}%>">
						<a href="#" class="dropdown-toggle">
							<i class="menu-icon  fa fa-pencil"></i>
							<span class="menu-text">Report</span>
							<b class="arrow fa fa-angle-down"></b>
						</a>

						<b class="arrow"></b>
						<ul class="submenu">
							<li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPFINANCE")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPFINANCE">
									<i class="menu-icon fa fa-caret-right"></i>
							Finance
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("REPSALES")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPSALES">
									<i class="menu-icon fa fa-caret-right"></i>
								Sales
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("REPPURCHASE")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPPURCHASE">
									<i class="menu-icon fa fa-caret-right"></i>
								Purchase
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("REPSTOCK")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPSTOCK">
									<i class="menu-icon fa fa-caret-right"></i>
							Stock
								</a>
								<b class="arrow"></b>
							</li>
							<li class="<%if(gen.gettable(request.getParameter("tp")).startsWith("REPBANK")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPBANK">
									<i class="menu-icon fa fa-caret-right"></i>
							Bank
								</a>
								<b class="arrow"></b>
							</li>
                                <li class="<%if(gen.gettable(request.getParameter("tp")).equalsIgnoreCase("REPTREATMENT")){%>active<%}%>">
								<a href="laporan.jsp?tp=REPTREATMENT">
									<i class="menu-icon fa fa-caret-right"></i>
								Treatment
								</a>
								<b class="arrow"></b>
                                </li>
                        </ul>
					</li>                 
                    <%}%>
				</ul><!-- /.nav-list -->

				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i id="sidebar-toggle-icon" class="ace-icon fa fa-angle-double-left ace-save-state" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>
			</div>


