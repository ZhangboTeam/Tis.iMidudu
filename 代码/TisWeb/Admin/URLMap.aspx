<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" runat="server">
    <article class="module width_full">

        <script runat="server">

            private int totalCount;
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

                totalCount = (int)TisWeb.Models.SqlHelper.ExecuteScalarText("select count(1) from URLMap");

                var dr = TisWeb.Models.SqlHelper.ExecuteReaderFromStoredProcedure("bsp_URLMap",
                   new System.Data.SqlClient.SqlParameter("@startIndex", AspNetPager1.StartRecordIndex),
                   new System.Data.SqlClient.SqlParameter("@endIndex", AspNetPager1.EndRecordIndex)
                   );

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
        <script>
            function AddNew() { 
                var data = {
                    newUrlCode: $("#newUrlCode").val(),
                    newToUrl: $("#newToUrl").val(),
                };
                if (data.newUrlCode == "") {
                    alert("input newUrlCode"); return;
                }
                if (data.newToUrl == "") {
                    alert("input newToUrl"); return;
                } 
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    url: "/Admin/Webservice.asmx/AddNewUrlMap",
                    data: JSON.stringify(data),
                    dataType: 'json',
                    success: function (result) {
                       
                        alert("ok");
                        window.location.reload();
                       
                    },
                    error: function (err) {
                        alert(err.responseText);
                    }
                });
            }
        </script>

        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <asp:Repeater ID="Repeater1" runat="server">
                    <HeaderTemplate>
                        <table class="tablesorter" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>UrlCode</th>
                                    <th>ToUrl</th>
                                    <th></th>
                                </tr>
                            </thead>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tbody>
                            <tr>
                                <td><%#Eval("UrlCode") %></td>
                                <td><%#Eval("ToUrl") %></td>
                                <td>
                                    <input type="button" value="Delete" class="alt_btn" />
                                </td>

                            </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        
                            <tr>
                                <td> 
                                    <input id="newUrlCode"  type="text"/>

                                </td>
                                <td> 
                                    <input id="newToUrl"  type="text"/></td>
                                <td>
                                    <input type="button" value="AddNew" class="alt_btn"  onclick="AddNew();"/>
                                </td>

                            </tr>
                        </tbody>
                    </table>
                    </FooterTemplate>
                </asp:Repeater>
                <webdiyer:AspNetPager ID="AspNetPager1" runat="server" Width="100%" UrlPaging="true" ShowPageIndexBox="Always" PageIndexBoxType="DropDownList"
                    FirstPageText="【首页】"
                    LastPageText="【尾页】" NextPageText="【后页】"
                    PrevPageText="【前页】" NumericButtonTextFormatString="【{0}】" TextAfterPageIndexBox="页" TextBeforePageIndexBox="转到第" HorizontalAlign="right" PageSize="20" OnPageChanged="AspNetPager1_PageChanged" EnableTheming="true" CustomInfoHTML="Page  <font color='red'><b>%CurrentPageIndex%</b></font> of  %PageCount%  Order %StartRecordIndex%-%EndRecordIndex%">
                </webdiyer:AspNetPager>
            </div>
            <!-- end of #tab1 -->



        </div>
        <!-- end of .tab_container -->

    </article>
</asp:Content>
