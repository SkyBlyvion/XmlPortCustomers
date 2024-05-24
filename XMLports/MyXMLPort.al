xmlport 50038 "CustomerExport"
{
    Caption = 'Customer Export';
    Direction = Export;
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
                fieldattribute(No; Customer."No.")
                {
                }
                fieldattribute(Name; Customer.Name)
                {
                }
                fieldattribute(PhoneNo; Customer."Phone No.")
                {
                }
                fieldattribute(Email; Customer."E-Mail")
                {
                }
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
}
