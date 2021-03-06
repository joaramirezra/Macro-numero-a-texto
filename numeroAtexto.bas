Attribute VB_Name = "NewMacros"
Public Function NroEnLetras(ByVal curNumero As Double, Optional blnO_Final As Boolean = True) As String
'Devuelve un n�mero expresado en letras.
'El par�metro blnO_Final se utiliza en la recursi�n para saber si se debe colocar
'la "O" final cuando la palabra es UN(O)
    Dim lngContDec As Long
    Dim lngContCent As Long
    Dim lngContMil As Long
    Dim lngContMillon As Long
    Dim strNumLetras As String
    Dim strNumero As Variant
    Dim strDecenas As Variant
    Dim strCentenas As Variant
    Dim blnNegativo As Boolean
    Dim blnPlural As Boolean
    
    If Int(curNumero) = 0# Then
        strNumLetras = "CERO"
    End If
    
    strNumero = Array(vbNullString, "UN", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", _
                   "OCHO", "NUEVE", "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", _
                   "QUINCE", "DIECISEIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", _
                   "VEINTE")

    strDecenas = Array(vbNullString, vbNullString, "VEINTI", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", _
                    "SETENTA", "OCHENTA", "NOVENTA", "CIEN")

    strCentenas = Array(vbNullString, "CIENTO", "DOSCIENTOS", "TRESCIENTOS", _
                     "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS", "SETECIENTOS", _
                     "OCHOCIENTOS", "NOVECIENTOS")

    If curNumero < 0# Then
        blnNegativo = True
        curNumero = Abs(curNumero)
    End If


    Do While curNumero >= 1000000#
        lngContMillon = lngContMillon + 1
        curNumero = curNumero - 1000000#
    Loop

    Do While curNumero >= 1000#
        lngContMil = lngContMil + 1
        curNumero = curNumero - 1000#
    Loop
    
    Do While curNumero >= 100#
        lngContCent = lngContCent + 1
        curNumero = curNumero - 100#
    Loop
    
    If Not (curNumero > 10# And curNumero <= 20#) Then
        Do While curNumero >= 10#
            lngContDec = lngContDec + 1
            curNumero = curNumero - 10#
        Loop
    End If
    
    If lngContMillon > 0 Then
        If lngContMillon >= 1 Then   'si el n�mero es >1000000 usa recursividad
            strNumLetras = NroEnLetras(lngContMillon, False)
            If Not blnPlural Then blnPlural = (lngContMillon > 1)
            lngContMillon = 0
        End If
        strNumLetras = Trim(strNumLetras) & strNumero(lngContMillon) & " MILLON" & _
                                                                    IIf(blnPlural, "ES ", " ")
    End If
    
    If lngContMil > 0 Then
        If lngContMil >= 1 Then   'si el n�mero es >100000 usa recursividad
            strNumLetras = strNumLetras & NroEnLetras(lngContMil, False)
            lngContMil = 0
        End If
        strNumLetras = Trim(strNumLetras) & strNumero(lngContMil) & " MIL "
    End If
    
    If lngContCent > 0 Then
        If lngContCent = 1 And lngContDec = 0 And curNumero = 0# Then
            strNumLetras = strNumLetras & "CIEN"
        Else
            strNumLetras = strNumLetras & strCentenas(lngContCent) & " "
        End If
    End If
    
    If lngContDec >= 1 Then
        If lngContDec = 1 Then
            strNumLetras = strNumLetras & strNumero(10)
        Else
            strNumLetras = strNumLetras & strDecenas(lngContDec)
        End If
        
        If lngContDec >= 3 And curNumero > 0# Then
            strNumLetras = strNumLetras & " Y "
        End If
    Else
        If curNumero >= 0# And curNumero <= 20# Then
            strNumLetras = strNumLetras & strNumero(curNumero)
            If curNumero = 1# And blnO_Final Then
                strNumLetras = strNumLetras
            End If
            NroEnLetras = strNumLetras
            Exit Function
        End If
    End If
    
    If curNumero > 0# Then
        strNumLetras = strNumLetras & strNumero(curNumero)
        If curNumero = 1# And blnO_Final Then
            strNumLetras = strNumLetras
        End If
    End If
    
    
    NroEnLetras = IIf(blnNegativo, "(" & strNumLetras & ")", strNumLetras)
End Function

Sub numero()

    Dim cadena() As String
    Dim cadenanumero() As String
    Dim parteEntera As Variant
    Dim parteDecimal As Variant
    Dim salida As Variant
    Dim numero As Double
    Dim real As Boolean
    
    With Selection
    cadena = Split(Selection, " ")
    End With
    cadenanumero = Split(cadena(0), ".")
        
         
    parteEntera = NroEnLetras(cadenanumero(0))
    
    If InStr(cadena(0), ".") <> 0 Then
        parteDecimal = NroEnLetras(cadenanumero(1))
        real = True
    End If
        
    If StrComp(cadena(1), "m2", vbTextCompare) = 0 Then
        If StrComp(cadenanumero(0), "1", vbTextCompare) = 0 Then
            salida = parteEntera & " metro cuadrado"
        Else: salida = parteEntera & " metros cuadrados"
        End If
        If real Then
            If StrComp(cadenanumero(1), "1", vbTextCompare) = 0 Then
                salida = salida & " con un dec�metro cuadrado"
            Else
                salida = salida & " con " & parteDecimal & " dec�metros cuadrados"
            End If
        End If
        
     ElseIf StrComp(cadena(1), "m.", vbTextCompare) = 0 Then
        If StrComp(cadenanumero(0), "1", vbTextCompare) = 0 Then
            salida = parteEntera & " metro "
        Else: salida = parteEntera & " metros "
        End If
        If real Then
            If StrComp(cadenanumero(1), "1", vbTextCompare) = 0 Then
                salida = salida & "con un cent�metro"
            Else
                salida = salida & "con " & parteDecimal & " cent�metros"
            End If
        End If
        
    Else: MsgBox "formato no valido!"
    
    End If
    
    salida = salida & " (" & Selection.Text & ")"
    Selection.Text = LCase(salida)
    
End Sub
