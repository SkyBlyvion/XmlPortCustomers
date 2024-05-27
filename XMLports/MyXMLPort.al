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
                RequestFilterFields = "No."; // Filter to select specific customer records
                XmlName = 'Customer';
                fieldattribute(No; Customer."No.") { } // Export/Import customer number
                fieldattribute(Name; Customer.Name) { } // Export/Import customer name
                fieldattribute(PhoneNo; Customer."Phone No.") { } // Export/Import customer phone number
                fieldattribute(Email; Customer."E-Mail") { } // Export/Import customer email
                textelement(Address)
                {
                    XmlName = 'Address';
                    fieldelement(Street; Customer.Address) { } // Export/Import customer street address
                    fieldelement(Zipcode; Customer."Post Code") { } // Export/Import customer postal code
                    fieldelement(City; Customer.City) { } // Export/Import customer city
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
        TempCustomer: Record Customer; // Temporary variable for customer record

    trigger OnPreXmlPort()
    begin
        // Initialize the temp customer record if needed
        if Customer.Get(Customer."No.") then
            TempCustomer := Customer;
    end;

    trigger OnPostXmlPort()
    begin
        // Update customer and contact information after XMLPort processing is complete
        if TempCustomer."No." <> '' then
            if TempCustomer.Get(TempCustomer."No.") then begin
                // Check and update contact information related to the customer
                UpdateRelevantContacts(TempCustomer);

                // Update customer fields with imported values
                TempCustomer.Name := Customer.Name;
                TempCustomer."Phone No." := Customer."Phone No.";
                TempCustomer."E-Mail" := Customer."E-Mail";
                TempCustomer.Address := Customer.Address;
                TempCustomer."Post Code" := Customer."Post Code";
                TempCustomer.City := Customer.City;
                TempCustomer.Modify();
            end;
    end;

    // Function to update relevant contacts of the customer
    procedure UpdateRelevantContacts(Customer: Record Customer)
    var
        Contact: Record Contact; // Record to handle contact details
        ContactRelation: Record "Contact Business Relation"; // Record to handle contact business relations
    begin
        // Iterate over all related contacts
        ContactRelation.SetRange("Link to Table", ContactRelation."Link to Table"::Customer);
        ContactRelation.SetRange("No.", Customer."No.");
        if ContactRelation.FindSet() then
            repeat
                if Contact.Get(ContactRelation."Contact No.") then begin
                    // Check if the contact is a person
                    if Contact.Type = Contact.Type::Person then begin
                        // Check if the contact's name matches the customer's name
                        if Contact.Name = Customer.Name then begin
                            // Update the relevant contact with the new information from the customer
                            Contact.Name := Customer.Name;
                            Contact."Phone No." := Customer."Phone No.";
                            Contact."E-Mail" := Customer."E-Mail";
                            Contact.Address := Customer.Address;
                            Contact."Post Code" := Customer."Post Code";
                            Contact.City := Customer.City;
                            Contact.Modify();
                        end;

                        // Ensure the business relation exists and is correct
                        if not ContactRelation.Get(Customer."No.", Contact."No.") then begin
                            ContactRelation.Init();
                            ContactRelation.Validate("Link to Table", ContactRelation."Link to Table"::Customer);
                            ContactRelation."No." := Customer."No.";
                            ContactRelation."Contact No." := Contact."No.";
                            ContactRelation.Insert();
                        end else begin
                            ContactRelation.Modify();
                        end;
                    end;
                end;
            until ContactRelation.Next() = 0;
    end;
}
