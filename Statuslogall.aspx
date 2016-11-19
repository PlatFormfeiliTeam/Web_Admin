<%@ Page Title="" Language="C#" MasterPageFile="~/SiteCommon.Master" AutoEventWireup="true" CodeBehind="Statuslogall.aspx.cs" Inherits="Web_Admin.Statuslogall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="renderto" style=" height:500px;">
        <div style="background-color:#5a86b5;font-size:15pt;text-align:center;width:100%; border-radius:15px; color:#ffffff;">报关报检业务查询</div>

        <div style="margin:5px 0px;">
            <asp:Label ID="LabCusno" runat="server" Text="客户编号：" ></asp:Label>
            <asp:TextBox ID="TxtCusno" runat="server" CssClass="input_text"></asp:TextBox>
            <asp:Label ID="LabKey" runat="server" Text="分KEY："></asp:Label>
            <asp:TextBox ID="TxtKey" runat="server" CssClass="input_text"></asp:TextBox>
            <asp:Button ID="BtnQuery" runat="server" Text="查&nbsp;&nbsp;&nbsp;&nbsp;询" OnClick="BtnQuery_Click" CssClass="eisobutton" />
        </div>

        <asp:Label ID="lbl_msg1" runat="server" Text=""></asp:Label>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"  Width="100%" OnPageIndexChanging="GridView1_PageIndexChanging"
              CellPadding="3" ForeColor="Black" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" AllowPaging="True" PageSize="15" GridLines="Both">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="TYPE" HeaderText="类别" >
                    </asp:BoundField>
                    <asp:BoundField DataField="CUSNO" HeaderText="企业编号" >
                    </asp:BoundField>
                    <asp:BoundField DataField="STATUSCODE" HeaderText="code" >
                    </asp:BoundField>
                    <asp:BoundField DataField="STATUSVALUE" HeaderText="value">
                    </asp:BoundField>
                    <asp:BoundField DataField="DIVIDEREDISKEY" HeaderText="分KEY" >
                    </asp:BoundField>
                </Columns>

                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
                <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#808080" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
            </asp:GridView>

        <asp:Label ID="lbl_msg2" runat="server" Text=""></asp:Label>
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False"  Width="100%" OnPageIndexChanging="GridView2_PageIndexChanging" 
            CellPadding="3" ForeColor="Black" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" AllowPaging="True" PageSize="15" GridLines="Both" >
            <AlternatingRowStyle BackColor="#CCCCCC" />
            <Columns>
                <asp:BoundField DataField="TYPE" HeaderText="类别" />
                <asp:BoundField DataField="CUSNO" HeaderText="企业编号" />
                <asp:BoundField DataField="STATUSCODE" HeaderText="code" />
                <asp:BoundField DataField="STATUSVALUE" HeaderText="value" />
            </Columns>
            
            <FooterStyle BackColor="#CCCCCC" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#808080" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#383838" />
        </asp:GridView>
    </div>
</asp:Content>
