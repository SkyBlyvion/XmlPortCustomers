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
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    CustomerExportImportHandler: Xmlport "CustomerExportImport";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin
                    // Create an OutStream from TempBlob
                    TempBlob.CreateOutStream(OutStream);

                    // Set the destination OutStream for the XmlPort
                    CustomerExportImportHandler.SetDestination(OutStream);

                    // Run the XmlPort to export data to the OutStream
                    CustomerExportImportHandler.Export();

                    // Create an InStream from TempBlob
                    TempBlob.CreateInStream(InStream);

                    // Set the file name
                    FileName := 'Customers.xml';

                    // Download the file using FileManagement.BLOBExport
                    FileManagement.BLOBExport(TempBlob, FileName, true);
                end;
            }

            action(ImportCustomers)
            {
                ApplicationArea = All;
                Caption = 'Import Customers from XML';
                ToolTip = 'Import Customers from XML';
                Image = Import;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    CustomerExportImportHandler: Xmlport "CustomerExportImport";
                    InStream: InStream;
                begin
                    // Upload the XML file and store it in TempBlob
                    FileManagement.BLOBImport(TempBlob, 'Import Customers');

                    // Create an InStream from TempBlob
                    TempBlob.CreateInStream(InStream);

                    // Set the source InStream for the XmlPort
                    CustomerExportImportHandler.SetSource(InStream);

                    // Run the XmlPort to import data from the InStream
                    CustomerExportImportHandler.Import();
                end;
            }
        }
    }
}
