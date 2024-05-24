pageextension 50039 "CustomerListExtXML" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action(ExportCustomers)
            {
                ApplicationArea = All;
                Caption = 'Export Customers to XML';
                ToolTip = 'Export Customers to XML';
                Image = ExportContact;
                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    TempBlob: Codeunit "Temp Blob";
                    CustomerExportHandler: Xmlport "CustomerExport";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin

                    // Create an OutStream from TempBlob
                    TempBlob.CreateOutStream(OutStream);

                    // Set the destination OutStream for the XmlPort
                    CustomerExportHandler.SetDestination(OutStream);

                    // Run the XmlPort to export data to the OutStream
                    CustomerExportHandler.Export();

                    // Create an InStream from TempBlob
                    TempBlob.CreateInStream(InStream);

                    // Set the file name
                    FileName := 'Customers.xml';

                    // Download the file using FileManagement.BLOBExport
                    FileManagement.BLOBExport(TempBlob, FileName, true);
                end;
            }
        }
    }
    var
        myInt: Integer;
}
