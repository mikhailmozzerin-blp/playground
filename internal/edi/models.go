package edi

type BLPEDIDocument struct {
	EdiType                          string                       `json:"ediType"`
	DocumentNumber                   string                       `json:"documentNumber,omitempty"`
	HeaderText                       string                       `json:"headerText,omitempty"`
	Assignment                       string                       `json:"assignment,omitempty"`
	VendorText                       string                       `json:"vendorText,omitempty"`
	PaymentReference                 string                       `json:"paymentReference,omitempty"`
	PaymentSlipIban                  string                       `json:"paymentSlipIban,omitempty"`
	DocumentType                     string                       `json:"documentType,omitempty"`
	InvoiceDate                      string                       `json:"invoiceDate,omitempty"`
	PostingDate                      string                       `json:"postingDate,omitempty"`
	ServiceRenderedDate              string                       `json:"serviceRenderedDate,omitempty"`
	DeliveryDate                     string                       `json:"deliveryDate,omitempty"`
	OrderDate                        string                       `json:"orderDate,omitempty"`
	TaxPointDate                     string                       `json:"taxPointDate,omitempty"`
	Currency                         string                       `json:"currency,omitempty"`
	BuyerAddress                     *InvoiceAddress              `json:"buyerAddress,omitempty"`
	BuyerVatIdentificationNumber     string                       `json:"buyerVatIdentificationNumber,omitempty"`
	BuyerGovernmentDestinationNumber string                       `json:"buyerGovernmentDestinationNumber,omitempty"`
	SellerAddress                    *InvoiceAddress              `json:"sellerAddress,omitempty"`
	BillerAddress                    *InvoiceAddress              `json:"billerAddress,omitempty"`
	ShipToAddress                    *InvoiceAddress              `json:"shipToAddress,omitempty"`
	SellerVatIdentificationNumber    string                       `json:"sellerVatIdentificationNumber,omitempty"`
	NetValue                         float64                      `json:"netValue,omitempty"`
	GrossValue                       float64                      `json:"grossValue,omitempty"`
	SubTaxAmounts                    []InvoiceSubTaxAmount        `json:"subTaxAmounts,omitempty"`
	TaxAmount                        float64                      `json:"taxAmount,omitempty"`
	PaymentTerms                     string                       `json:"paymentTerms,omitempty"`
	PaymentTermsDescription          string                       `json:"paymentTermsDescription,omitempty"`
	PaymentTermsDueDate              string                       `json:"paymentTermsDueDate,omitempty"`
	PaymentTermsMethod               string                       `json:"paymentTermsMethod,omitempty"`
	PaymentTermsMethodDescription    string                       `json:"paymentTermsMethodDescription,omitempty"`
	PaymentTermsDetails              []InvoicePaymentTermsDetails `json:"paymentTermsDetails,omitempty"`
	BankAddresses                    []BankInformation            `json:"bankAddresses,omitempty"`
	InvoiceType                      string                       `json:"invoiceType,omitempty"`
}

type InvoiceAddress struct {
	ID          string `json:"id,omitempty"`
	Name        string `json:"name,omitempty"`
	Street      string `json:"street,omitempty"`
	City        string `json:"city,omitempty"`
	Postcode    string `json:"postcode,omitempty"`
	CountryCode string `json:"countrycode,omitempty"`
	Email       string `json:"email"`
	PhoneNumber string `json:"phonenumber,omitempty"`
}

type InvoiceSubTaxAmount struct {
	Percent float64 `json:"percent,omitempty"`
	Amount  float64 `json:"amount,omitempty"`
}

type InvoicePaymentTermsDetails struct {
	BaselineDate string  `json:"baselineDate,omitempty"`
	DueDate      string  `json:"dueDate"`
	Discount     float64 `json:"discount,omitempty"`
	Days         int32   `json:"days,omitempty"`
	GrossTotal   float64 `json:"grossTotal,omitempty"`
}

type BankInformation struct {
	ID            string `json:"id,omitempty"`
	Name          string `json:"name,omitempty"`
	IBAN          string `json:"iban,omitempty"`
	AccountNumber string `json:"accountNumber,omitempty"`
	Swift         string `json:"swift,omitempty"`
	Currency      string `json:"currency,omitempty"`
}
