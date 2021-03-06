﻿Imports System.IO
Imports System.Data
Imports System.Data.Odbc
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports Common_BOL
Imports Common_PPT
Imports System.Configuration
Imports System.Math

Public Class StoreIPRReportView


    Dim strServerUserName As String = String.Empty
    Dim strServerPassword As String = String.Empty
    Dim strDSN As String = String.Empty

    Private Sub StoreIPRReportView_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        strDSN = GlobalPPT.SelectedDB.DSN
        strServerUserName = GlobalPPT.SelectedDB.User
        strServerPassword = GlobalPPT.SelectedDB.Password

        Dim constr As String = " DSN=" & strDSN & ";UID=" & strServerUserName & "; pwd=" & strServerPassword & ";"

        Dim con As New Odbc.OdbcConnection
        Dim cmd As New Odbc.OdbcCommand
        Dim cmd1 As New Odbc.OdbcCommand
        con = New Odbc.OdbcConnection(constr)
        con.Open()




        Dim rpt As New IPRReportForIPRNo
        Dim tblAdt As New Odbc.OdbcDataAdapter
        Dim tblAdt1 As New Odbc.OdbcDataAdapter
        Dim ds As New DataSet
        Dim ds1 As New DataSet
        cmd.Connection = con

        cmd.CommandText = "Store.IPRReportForIPRNO '" & StoreIPRReportFrm.strSTIPRNo & "','" & GlobalPPT.strEstateID & "','" & GlobalPPT.strActMthYearID & "'"
        cmd.CommandType = CommandType.StoredProcedure
        tblAdt.SelectCommand = cmd
        tblAdt.Fill(ds, "IPRReportForIPRNO;1")

        If ds.Tables(0).Rows.Count > 0 Then
            '
            Dim txtBudget As CrystalDecisions.CrystalReports.Engine.TextObject
            txtBudget = CType(rpt.ReportDefinition.ReportObjects.Item("txtBudget"), CrystalDecisions.CrystalReports.Engine.TextObject)
            Dim intBudget As Integer
            If ds.Tables.Count > 0 Then
                If GlobalPPT.IntLoginMonth = 1 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M1")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 2 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M2")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 3 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M3")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 4 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M4")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 5 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M5")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 6 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M6")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 7 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M7")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 8 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M8")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 9 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M9")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 10 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M10")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 11 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M11")
                    txtBudget.Text = intBudget
                ElseIf GlobalPPT.IntLoginMonth = 12 Then
                    intBudget = ds.Tables(0).Rows(0).Item("M12")
                    txtBudget.Text = intBudget
                End If
            End If

            cmd1.Connection = con
            cmd1.CommandText = "Store.IPRReportForIPRNOREALISASI '" & StoreIPRReportFrm.strUsageCOAID & "','" & GlobalPPT.strEstateID & "','" & GlobalPPT.IntLoginMonth & "','" & GlobalPPT.intLoginYear & "'"
            cmd1.CommandType = CommandType.StoredProcedure
            tblAdt1.SelectCommand = cmd1
            tblAdt1.Fill(ds1, "IPRReportForIPRNOREALISASI;1")

            Dim txtRealisasi As CrystalDecisions.CrystalReports.Engine.TextObject
            txtRealisasi = CType(rpt.ReportDefinition.ReportObjects.Item("txtRealisasi"), CrystalDecisions.CrystalReports.Engine.TextObject)
            Dim intREALISASI As Integer
            intREALISASI = ds1.Tables(0).Rows(0).Item("REALISASI")
            txtRealisasi.Text = intREALISASI

            Dim txtSisa As CrystalDecisions.CrystalReports.Engine.TextObject
            txtSisa = CType(rpt.ReportDefinition.ReportObjects.Item("txtSisa"), CrystalDecisions.CrystalReports.Engine.TextObject)
            txtSisa.Text = abs(txtBudget.Text - txtRealisasi.Text)

            'Dim txtPrintedby As CrystalDecisions.CrystalReports.Engine.TextObject
            'txtPrintedby = CType(rpt.ReportDefinition.ReportObjects.Item("txtPrintedby"), CrystalDecisions.CrystalReports.Engine.TextObject)
            'txtPrintedby.Text = GlobalPPT.strDisplayName

            'Dim txtEstateName As CrystalDecisions.CrystalReports.Engine.TextObject
            'txtEstateName = CType(rpt.ReportDefinition.ReportObjects.Item("txtEstateName"), CrystalDecisions.CrystalReports.Engine.TextObject)
            'Dim strArray As String()
            'strArray = GlobalPPT.strEstateName.Split("-")
            'txtEstateName.Text = strArray(1)

            rpt.SetDataSource(ds)
            CrystalReportViewer1.ReportSource = rpt
            '
        Else
            rpt.SetDataSource(ds)
            CrystalReportViewer1.ReportSource = rpt
        End If

    End Sub

End Class