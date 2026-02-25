package edi

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

func UploadBLPFormat(c echo.Context) error {
	docID := c.Param("docId")

	docUUID, err := uuid.Parse(docID)
	if err != nil {
		log.Printf("Invalid document ID: %v", err)
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("invalid document ID: %v", err))
	}

	log.Printf("Received request for document ID: %s", docUUID)

	body, err := io.ReadAll(c.Request().Body)
	if err != nil {
		log.Printf("Error reading request body: %v", err)
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("error reading request body: %v", err))
	}

	log.Printf("Request body (raw): %s", string(body))

	var params BLPEDIDocument
	if err := json.Unmarshal(body, &params); err != nil {
		log.Printf("Error parsing request body: %v", err)
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("error parsing request body: %v", err))
	}

	log.Printf("Parsed BLPEDIDocument:")
	log.Printf("  EdiType: %s", params.EdiType)
	log.Printf("  DocumentNumber: %s", params.DocumentNumber)
	log.Printf("  InvoiceDate: %s", params.InvoiceDate)
	log.Printf("  Currency: %s", params.Currency)
	log.Printf("  NetValue: %.2f", params.NetValue)
	log.Printf("  GrossValue: %.2f", params.GrossValue)
	log.Printf("  TaxAmount: %.2f", params.TaxAmount)

	if params.BuyerAddress != nil {
		log.Printf("  BuyerAddress: %+v", params.BuyerAddress)
	}
	if params.SellerAddress != nil {
		log.Printf("  SellerAddress: %+v", params.SellerAddress)
	}

	return c.JSON(http.StatusOK, params)
}
