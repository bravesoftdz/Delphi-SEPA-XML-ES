unit senCille.SEPAAuxClasses;

   {https://github.com/sencille/Delphi-SEPA-XML-ES
    Juan C.Cilleruelo Gonzalo. senCille.es
    Based on a previous version donated by:
          https://github.com/cocosistemas/Delphi-SEPA-XML-ES
          Diego J.Mu�oz. Freelance. Cocosistemas.com         }

interface

uses System.Generics.Collections;

type
  {Operaci�n de Cobro o Pago}
  TsepaOperation = class {un Cobro}
    OpId            :string; //id unico cobro, ejemplo:20130930Fra.509301
    Import          :Double;
    Concept         :string;
    BIC             :string;
    IBAN            :string;
    Name            :string;
    {--- exclusive for Collection ---}
    IdMandator      :string;
    DateOfSignature :TDateTime; {of the mandator}
  end;

  { un conjunto de cobros por Ordenante, lo utilizamos por si utilizan                                        }
  { cobros a ingresar en diferentes cuentas (el <PmtInf> contiene la info del Ordenante, con su cuenta; y los }
  { cobros relacionados con este Ordenante/cuenta de abono                                                    }
  TsepaInitiator = class {un Ordenante}
  private
    FOperations :TList<TsepaOperation>; {Collects}
  public
    PaymentId :string; //Ejemplo: 2013-10-28_095831Remesa 218 UNICO POR Ordenante
    Name      :string;
    IBAN      :string;
    BIC       :string;
    {--- Exlusive for Collection ---}
    IdInitiator :string; //el ID �nico del ordenante, normalmente dado por el banco
    {-------------------------------}
    constructor Create;
    destructor Destroy; override;
    function GetTotalImport:Double;
    property Operations :TList<TsepaOperation> read FOperations write FOperations;
  end;

implementation

{ TsepaInitiator }
constructor TsepaInitiator.Create;
begin
   inherited;
   FOperations := TList<TsepaOperation>.Create;
end;

destructor TsepaInitiator.Destroy;
begin
   Operations.Free;
   inherited;
end;

function TsepaInitiator.GetTotalImport: Double;
var i :TsepaOperation;
begin
   Result := 0;
   for i in FOperations do begin
      Result := Result + i.Import;
   end;
end;

end.
