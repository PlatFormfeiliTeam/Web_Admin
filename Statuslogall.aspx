<%@ Page Title="" Language="C#" MasterPageFile="~/SiteCommon.Master" AutoEventWireup="true" CodeBehind="Statuslogall.aspx.cs" Inherits="Web_Admin.Statuslogall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="renderto" style="height:500px;">
    <asp:Label ID="LabCusno" runat="server" Text="客户编号："></asp:Label>
        <asp:TextBox ID="TxtCusno" runat="server"></asp:TextBox>
        <asp:Label ID="LabKey" runat="server" Text="分KEY："></asp:Label>
        <asp:TextBox ID="TxtKey" runat="server"></asp:TextBox>
        <asp:Button ID="BtnQuery" runat="server" Text="查询" OnClick="BtnQuery_Click" />
    

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"  Width="800px"
          OnPageIndexChanging="GridView1_PageIndexChanging"
          CellPadding="4" ForeColor="#333333" GridLines="None" >
            <AlternatingRowStyle BackColor="White" />
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

            <EditRowStyle BackColor="#7C6F57" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#E3EAEB" />
            <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F8FAFA" />
            <SortedAscendingHeaderStyle BackColor="#246B61" />
            <SortedDescendingCellStyle BackColor="#D4DFE1" />
            <SortedDescendingHeaderStyle BackColor="#15524A" />

        </asp:GridView>
        <br />
        <br />
        <br />
        <h2>
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label></h2>
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False"  Width="800px" OnPageIndexChanging="GridView2_PageIndexChanging" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4">
            <Columns>
                <asp:BoundField DataField="TYPE" HeaderText="类别" />
                <asp:BoundField DataField="CUSNO" HeaderText="企业编号" />
                <asp:BoundField DataField="STATUSCODE" HeaderText="code" />
                <asp:BoundField DataField="STATUSVALUE" HeaderText="value" />
            </Columns>
            <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" />
            <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
            <RowStyle BackColor="White" ForeColor="#330099" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
            <SortedAscendingCellStyle BackColor="#FEFCEB" />
            <SortedAscendingHeaderStyle BackColor="#AF0101" />
            <SortedDescendingCellStyle BackColor="#F6F0C0" />
            <SortedDescendingHeaderStyle BackColor="#7E0000" />
        </asp:GridView>
    </div>
</asp:Content>
