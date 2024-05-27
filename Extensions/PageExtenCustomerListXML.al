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
                    TempBlob: Codeunit "Temp Blob"; // Temporary storage for BLOB data
                    FileManagement: Codeunit "File Management"; // File management utility
                    CustomerExportImportHandler: Xmlport "CustomerExportImport"; // XMLPort for handling customer export/import
                    OutStream: OutStream; // Stream for writing data
                    InStream: InStream; // Stream for reading data
                    FileName: Text; // Name of the file to be created
                begin
                    // Create an OutStream from TempBlob for writing data
                    TempBlob.CreateOutStream(OutStream);

                    // Set the destination OutStream for the XmlPort
                    CustomerExportImportHandler.SetDestination(OutStream);

                    // Run the XmlPort to export customer data to the OutStream
                    CustomerExportImportHandler.Export();

                    // Create an InStream from TempBlob for reading data
                    TempBlob.CreateInStream(InStream);

                    // Set the file name for the exported data
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
                    TempBlob: Codeunit "Temp Blob"; // Temporary storage for BLOB data
                    FileManagement: Codeunit "File Management"; // File management utility
                    CustomerExportImportHandler: Xmlport "CustomerExportImport"; // XMLPort for handling customer export/import
                    InStream: InStream; // Stream for reading data
                begin
                    // Upload the XML file and store it in TempBlob
                    FileManagement.BLOBImport(TempBlob, 'Import Customers');

                    // Check if TempBlob has value to ensure it contains data
                    if TempBlob.HasValue() then begin

                        // Create an InStream from TempBlob for reading data
                        TempBlob.CreateInStream(InStream);

                        // Set the source InStream for the XmlPort
                        CustomerExportImportHandler.SetSource(InStream);

                        // Run the XmlPort to import customer data from the InStream
                        CustomerExportImportHandler.Import();

                        // Optionally, display a success message to the user
                        Message('Customers have been successfully imported.');
                    end else begin
                        // Display an error message if the import fails
                        Error('Failed to import the customers. Please check the XML file and try again.');
                    end;
                end;
            }
        }
    }
}
