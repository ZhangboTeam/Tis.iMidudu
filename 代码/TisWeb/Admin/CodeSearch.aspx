<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" runat="server">
     <div>
    <label>使用城市查或者code</label><input name="key" type="text"  id="key"  placeholder="城市或者code查询"/>
        <%--<asp:TextBox ID="key" runat="server" ></asp:TextBox>--%>
         <button type="submit" class="login-button" id ="ok">
    <%--<input type="submit" onclick="dosearch();"  value="搜索"class="alt_btn"/>--%>
      <%--  onclick="dosearch();"--%>
    </div>
     <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource1" >
                        <HeaderTemplate>
                            <table class="tablesorter" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>浏览者城市</th>
                                        <th width="50">数量</th>
                                    </tr>
                                </thead>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tbody>
                                 <tr>
                                    <td><%#Eval("province") %></td>   
                                    <td><%#Eval("count province") %></td> 
                                </tr>
                        </ItemTemplate>
                        <FooterTemplate>

                            </tbody>
                    </table>
                            
                        </FooterTemplate>
                    </asp:Repeater>

     <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:TisConnectionString %>" SelectCommand="SELECT province,count(*) as 'count province' FROM [ViewHistory] WHERE ([UrlCode] = @UrlCode) group by province">
         <SelectParameters>
             <asp:SessionParameter DefaultValue="001" Name="UrlCode" SessionField="key" Type="String" />
         </SelectParameters>
     </asp:SqlDataSource>

</asp:Content>
