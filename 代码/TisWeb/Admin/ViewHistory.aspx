<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" runat="server">
        <script runat="server">

            private int totalCount;
            //private int totalCount2;
            protected override void OnLoad(EventArgs e)
            {
                base.OnLoad(e);
                if (!IsPostBack)
                {
                    this.LoadData();
                    AspNetPager1.RecordCount = totalCount;
                    //bindData(); //使用url分页，只需在分页事件处理程序中绑定数据即可，无需在Page_Load中绑定，否则会导致数据被绑定两次
                }
            }

            private System.Data.SqlClient.SqlDataReader LoadData()
            {

                totalCount = (int)TisWeb.Models.SqlHelper.ExecuteScalarText("select count(1) from ViewHistory");

                var dr = TisWeb.Models.SqlHelper.ExecuteReaderFromStoredProcedure("bsp_ViewHistory",
                   new System.Data.SqlClient.SqlParameter("@startIndex", AspNetPager1.StartRecordIndex),
                   new System.Data.SqlClient.SqlParameter("@endIndex", AspNetPager1.EndRecordIndex)
                   );
               //this.totalCount2=(int)TisWeb.Models.SqlHelper.ExecuteScalarText("select  max([city] ) from ViewHistory  where city  like '%' + @City + '%' ", City));
                //this.totalCount2 = (int)TisWeb.Models.SqlHelper.ExecuteScalarText("select  isnull(max(totalCount2)) from ViewHistory");
                return dr;
            }
            public override void DataBind()
            {
                this.Repeater1.DataSource = this.LoadData();
                base.DataBind();

            }


            protected void AspNetPager1_PageChanged(object src, EventArgs e)
            {
                this.DataBind();
            }
        </script>
      

    <article class="module width_full">
         
            <header> 

            </header>
            <div class="tab_container">
                <div id="tab1" class="tab_content">
                    <asp:Repeater ID="Repeater1" runat="server">
                        <HeaderTemplate>
                            <table class="tablesorter" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th width="50">code</th>
                                        <th>浏览者IP</th>
                                        <th>浏览者国家</th>
                                        <th>浏览者城市</th>
                                        <th>浏览者系统</th>
                                        <th>浏览时间</th>
                                    </tr>
                                </thead>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tbody>
                                <tr>
                                    <td><%#Eval("UrlCode") %></td>   
                                    <td><%#Eval("IP") %></td> 
                                    <td><%#Eval("country") %></td>
                                    <td><%#Eval("city") %></td>
                                    <td><%#Eval("os") %></td>
                                    
                                    <td><%#Eval("ViewDate") %></td>
                                </tr>
                        </ItemTemplate>
                        <FooterTemplate>

                            
                            </tbody>
                    </table>
                            
                        </FooterTemplate>
                    </asp:Repeater>
                    <webdiyer:AspNetPager ID="AspNetPager1" runat="server" Width="100%" UrlPaging="true" ShowPageIndexBox="Always" PageIndexBoxType="DropDownList" ShowCustomInfoSection="Left"
                        FirstPageText="【首页】"
                        LastPageText="【尾页】" NextPageText="【后页】"
                        PrevPageText="【前页】" NumericButtonTextFormatString="【{0}】" TextAfterPageIndexBox="页" TextBeforePageIndexBox="转到第" HorizontalAlign="right" PageSize="10" OnPageChanged="AspNetPager1_PageChanged" EnableTheming="true" CustomInfoHTML="当前第  <font color='red'><b>%CurrentPageIndex%</b></font> 页,共  %PageCount%  页 ,总共:%RecordCount% 条数据">
                    </webdiyer:AspNetPager>
                    <%--<div class="post_message">
                <label>汇总：&nbsp&nbsp&nbsp&nbsp 有</label>
                <label><%#totalCount %></label>
                <label>人扫码&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 其中</label>
                <label><% %></label>
                <label>人最多&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp </label>
                <label><% %>被扫最多</label>
                

            </div>--%>
            <div class="submit_link">
                <input type="submit" value="导出Excel" class="alt_btn"  />
            </div>
                </div>
                <!-- end of #tab1 -->



            </div>
            <!-- end of .tab_container -->
        
        </article>
</asp:Content>
