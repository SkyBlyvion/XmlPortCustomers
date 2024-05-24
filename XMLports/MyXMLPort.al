xmlport 50038 "CustomerExportImport"
{
    Caption = 'Customer Export/Import';
    Direction = Both;
    Format = Xml;

    schema
    {
        textelement(Customers)
        {
            XmlName = 'Customers';
            tableelement(Customer; Customer)
            {
                RequestFilterFields = "No.";
                XmlName = 'Customer';
                fieldattribute(No; Customer."No.") { }
                fieldattribute(Name; Customer.Name) { }
                fieldattribute(PhoneNo; Customer."Phone No.") { }
                fieldattribute(Email; Customer."E-Mail") { }
                textelement(Address)
                {
                    XmlName = 'Address';
                    fieldelement(Street; Customer.Address) { }
                    fieldelement(Zipcode; Customer."Post Code") { }
                    fieldelement(City; Customer.City) { }
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(FilterGroup)
                {
                    field(Name; Customer."Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        TempCustomer: Record Customer;

    trigger OnPreXmlPort()
    begin
        // Code to run before XMLPort processing starts
        if Customer.Get(Customer."No.") then begin
            TempCustomer := Customer;
        end;
    end;

    trigger OnPostXmlPort()
    begin
        // This runs after the XMLPort processing is complete
        if TempCustomer."No." <> '' then begin
            TempCustomer.Name := Customer.Name;
            TempCustomer."Phone No." := Customer."Phone No.";
            TempCustomer."E-Mail" := Customer."E-Mail";
            TempCustomer.Address := Customer.Address;
            TempCustomer."Post Code" := Customer."Post Code";
            TempCustomer.City := Customer.City;
            TempCustomer.Modify();
        end;
    end;
}
