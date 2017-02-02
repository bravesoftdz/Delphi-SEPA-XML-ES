unit senCille.CustomSEPA;

   {
   {
   https://github.com/sencille/Delphi-SEPA-XML-ES
   Juan C.Cilleruelo Gonzalo. senCille.es
   Based on a previous version donated by:
          https://github.com/cocosistemas/Delphi-SEPA-XML-ES
          Diego J.Mu�oz. Freelance. Cocosistemas.com
   }


interface
type
  TCustomSEPA = class
  private
  protected
  const
    SCHEMA_19                    = 'pain.008.001.02';
    SCHEMA_34                    = 'pain.001.001.03';
    INITIATOR_NAME_MAX_LENGTH    = 70;
    BENEFICIARIO_NAME_MAX_LENGTH = 70;
    DEUDOR_NAME_MAX_LENGTH       = 70;
    ORDENANTE_NAME_MAX_LENGTH    = 70;
    RMTINF_MAX_LENGTH            = 140;
    MNDTID_MAX_LENGTH            = 35;

    function  CleanStr(AString :string; ALength :Integer = -1):string;
    procedure WriteAccountIdentification(var fTxt :TextFile; sIBAN :string);
    procedure WriteBICInfo(var fTxt :TextFile; sBIC :string);
    function  GenerateUUID:string;
    function  FormatDateTimeXML(const d :TDateTime                          ):string;
    function  FormatAmountXML  (const d :Currency; const Digits :Integer = 2):string;
    function  FormatDateXML    (const d :TDateTime                          ):string;
  public
  end;

implementation

uses System.SysUtils, System.Math;

function TCustomSEPA.CleanStr(AString :string; ALength :Integer = -1):string;
var i :Integer;
begin
   Result := AString;
   Result := StringReplace(Result, '�', 'a', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'A', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'e', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'E', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'i', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'I', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'o', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'O', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'u', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'U', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'A', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'e', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'E', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'i', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'I', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'o', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'O', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'u', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'U', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'O', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'o', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'N', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'n', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'C', [rfReplaceAll]);
   Result := StringReplace(Result, '�', 'c', [rfReplaceAll]);

   {Change all unallowed characters by a space}
   for i := 1 to Length(Result) do begin
      if not(Ord(Result[i]) in [65..90, 97..122, 48..57, 47, 45, 63, 58, 40, 41, 46, 44, 39, 43, 32]) then Result[i] := ' ';
   end;
   // Convertir a may�sculas
   //Result := AnsiUpperCase(Result);

   // Codificar a UTF8
   Result := Utf8Encode(Trim(Result));
   if (ALength >= 0) and (Length(Result) > ALength) then Result := Copy(Result, 1, ALength);
end;

procedure TCustomSEPA.WriteAccountIdentification(var fTxt :TextFile; sIBAN :string);
begin
   WriteLn(FTxt, '<Id><IBAN>'+CleanStr(sIBAN)+'</IBAN></Id>');
end;

procedure TCustomSEPA.WriteBICInfo(var fTxt :TextFile; sBIC :string);
begin
  {if (BIC = '') and (OthrID <> '') then
     WriteLn(FsTxt, '<FinInstnId><Othr><Id>'+uSEPA_CleanString(OthrID)+'</Id></Othr></FinInstnId>')
   else}
   WriteLn(FTxt, '<FinInstnId><BIC>'+CleanStr(sBIC)+'</BIC></FinInstnId>');
end;

function TCustomSEPA.GenerateUUID:string;
var UId :TGuid;
    Res :HResult;
begin
   Res := CreateGuid(Uid);
   if Res = S_OK then begin
      Result := GuidToString(UId);
      Result := StringReplace(Result, '-', '', [rfReplaceAll]);
      Result := StringReplace(Result, '{', '', [rfReplaceAll]);
      Result := StringReplace(Result, '}', '', [rfReplaceAll]);
   end
   else Result := IntToStr(RandomRange(10000, High(Integer)));  // fallback to simple random number
end;

function TCustomSEPA.FormatDateXML(const d: TDateTime): String;
begin
   Result := FormatDateTime('yyyy"-"mm"-"dd', d);
end;

function TCustomSEPA.FormatAmountXML(const d: Currency; const digits: Integer = 2): String;
var OldDecimalSeparator: Char;
    {$if CompilerVersion>22}  //superiores a xe
    FS: TFormatSettings;
    {$ifend}
begin
   {$if CompilerVersion>22}
     OldDecimalSeparator := FS.DecimalSeparator;
     FS.DecimalSeparator := '.';
   {$else}
     OldDecimalSeparator := DecimalSeparator;
     DecimalSeparator := '.';
   {$ifend}
   Result := CurrToStrF(d, ffFixed, digits);
   {$if CompilerVersion>22}
     FS.DecimalSeparator := OldDecimalSeparator;
   {$else}
     DecimalSeparator := OldDecimalSeparator;
   {$ifend}
end;

function TCustomSEPA.FormatDateTimeXML(const d: TDateTime): String;
begin
   Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"."zzz"Z"', d);
end;

end.
