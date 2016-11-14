﻿<%@ Page Title="" Language="C#" MasterPageFile="~/SiteCommon.Master" AutoEventWireup="true" CodeBehind="Declareall.aspx.cs" Inherits="Web_Admin.Declareall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="renderto" style="height:500px;">
    <asp:Label ID="LabCusno" runat="server" Text="客户编号："></asp:Label>
    <asp:TextBox ID="TxtCusno" runat="server"></asp:TextBox>
    <asp:Label ID="LabKey" runat="server" Text="分KEY："></asp:Label>
    <asp:TextBox ID="TxtKey" runat="server"></asp:TextBox>
    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="查询" />
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="GridView1_PageIndexChanging">

          <Columns>
                <asp:BoundField DataField="DECLARATIONCODE" HeaderText="报关单号" >
                </asp:BoundField>
                <asp:BoundField DataField="TRADECODE" HeaderText="贸易方式" >
                </asp:BoundField>
                <asp:BoundField DataField="TRANSNAME" HeaderText="运输工具" >
                </asp:BoundField>
                <asp:BoundField DataField="GOODSNUM" HeaderText="件数">
                </asp:BoundField>
                <asp:BoundField DataField="GOODSGW" HeaderText="毛重" >
                </asp:BoundField>

              <asp:BoundField DataField="SHEETNUM" HeaderText="报关单张数" >
                </asp:BoundField>
              <asp:BoundField DataField="COMMODITYNUM" HeaderText="商品项数" >
                </asp:BoundField>
                  <asp:BoundField DataField="CUSTOMSSTATUS" HeaderText="海关状态" >
                </asp:BoundField>
                  <asp:BoundField DataField="MODIFYFLAG" HeaderText="删改单标志" >
                </asp:BoundField>
                  <asp:BoundField DataField="PREDECLCODE" HeaderText="预制单编号" >
                </asp:BoundField>
                  <asp:BoundField DataField="CUSNO" HeaderText="企业编号" >
                </asp:BoundField>
                 <asp:BoundField DataField="OLDDECLARATIONCODE" HeaderText="旧报关单号" >
                </asp:BoundField>
               <asp:BoundField DataField="ISDEL" HeaderText="是否删除" >
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
    <br /><br /><br />
    <h2><asp:Label ID="Label1" runat="server"></asp:Label></h2>
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="GridView2_PageIndexChanging">
                <Columns>
                <asp:BoundField DataField="DECLARATIONCODE" HeaderText="报关单号" >
                </asp:BoundField>
                <asp:BoundField DataField="TRADECODE" HeaderText="贸易方式" >
                </asp:BoundField>
                <asp:BoundField DataField="TRANSNAME" HeaderText="运输工具" >
                </asp:BoundField>
                <asp:BoundField DataField="GOODSNUM" HeaderText="件数">
                </asp:BoundField>
                <asp:BoundField DataField="GOODSGW" HeaderText="毛重" >
                </asp:BoundField>

              <asp:BoundField DataField="SHEETNUM" HeaderText="报关单张数" >
                </asp:BoundField>
              <asp:BoundField DataField="COMMODITYNUM" HeaderText="商品项数" >
                </asp:BoundField>
                  <asp:BoundField DataField="CUSTOMSSTATUS" HeaderText="海关状态" >
                </asp:BoundField>
                  <asp:BoundField DataField="MODIFYFLAG" HeaderText="删改单标志" >
                </asp:BoundField>
                  <asp:BoundField DataField="PREDECLCODE" HeaderText="预制单编号" >
                </asp:BoundField>
                  <asp:BoundField DataField="CUSNO" HeaderText="企业编号" >
                </asp:BoundField>
                 <asp:BoundField DataField="OLDDECLARATIONCODE" HeaderText="旧报关单号" >
                </asp:BoundField>
               <asp:BoundField DataField="ISDEL" HeaderText="是否删除" >
                </asp:BoundField>
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
