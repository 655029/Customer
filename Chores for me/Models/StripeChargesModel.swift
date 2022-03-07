//
//  StripeChargesModel.swift
//  Chores for me
//
//  Created by Ios Mac on 08/11/21.
//

import Foundation



struct StripeChargesModel : Codable {
    let id : String?
    let object : String?
    let amount : Int?
    let amount_captured : Int?
    let amount_refunded : Int?
    let application : String?
    let application_fee : String?
    let application_fee_amount : String?
    let balance_transaction : String?
    let billing_details : BillingDetails?
    let calculated_statement_descriptor : String?
    let captured : Bool?
    let created : Int?
    let currency : String?
    let customer : String?
    let description : String?
    let destination : String?
    let dispute : String?
    let disputed : Bool?
    let failure_code : String?
    let failure_message : String?
    let fraud_details : FraudDetails?
    let invoice : String?
    let livemode : Bool?
    let metadata : Metadata?
    let on_behalf_of : String?
    let order : String?
    let outcome : Outcome?
    let paid : Bool?
    let payment_intent : String?
    let payment_method : String?
    let payment_method_details : PaymentMethodDetails?
    let receipt_email : String?
    let receipt_number : String?
    let receipt_url : String?
    let refunded : Bool?
    let refunds : Refunds?
    let review : String?
    let shipping : String?
    let source : Source?
    let source_transfer : String?
    let statement_descriptor : String?
    let statement_descriptor_suffix : String?
    let status : String?
    let transfer_data : String?
    let transfer_group : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case object = "object"
        case amount = "amount"
        case amount_captured = "amount_captured"
        case amount_refunded = "amount_refunded"
        case application = "application"
        case application_fee = "application_fee"
        case application_fee_amount = "application_fee_amount"
        case balance_transaction = "balance_transaction"
        case billing_details = "billing_details"
        case calculated_statement_descriptor = "calculated_statement_descriptor"
        case captured = "captured"
        case created = "created"
        case currency = "currency"
        case customer = "customer"
        case description = "description"
        case destination = "destination"
        case dispute = "dispute"
        case disputed = "disputed"
        case failure_code = "failure_code"
        case failure_message = "failure_message"
        case fraud_details = "fraud_details"
        case invoice = "invoice"
        case livemode = "livemode"
        case metadata = "metadata"
        case on_behalf_of = "on_behalf_of"
        case order = "order"
        case outcome = "outcome"
        case paid = "paid"
        case payment_intent = "payment_intent"
        case payment_method = "payment_method"
        case payment_method_details = "payment_method_details"
        case receipt_email = "receipt_email"
        case receipt_number = "receipt_number"
        case receipt_url = "receipt_url"
        case refunded = "refunded"
        case refunds = "refunds"
        case review = "review"
        case shipping = "shipping"
        case source = "source"
        case source_transfer = "source_transfer"
        case statement_descriptor = "statement_descriptor"
        case statement_descriptor_suffix = "statement_descriptor_suffix"
        case status = "status"
        case transfer_data = "transfer_data"
        case transfer_group = "transfer_group"
    }
}

struct BillingDetails : Codable {
    let address : Address?
    let email : String?
    let name : String?
    let phone : String?

    enum CodingKeys: String, CodingKey {

        case address = "address"
        case email = "email"
        case name = "name"
        case phone = "phone"
    }}

struct FraudDetails : Codable {

}

struct Metadata : Codable {


}

struct Outcome : Codable {
    let network_status : String?
    let reason : String?
    let risk_level : String?
    let risk_score : Int?
    let seller_message : String?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case network_status = "network_status"
        case reason = "reason"
        case risk_level = "risk_level"
        case risk_score = "risk_score"
        case seller_message = "seller_message"
        case type = "type"
    }
}

struct PaymentMethodDetails : Codable {
    let card : Card?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case card = "card"
        case type = "type"
    }
}

struct Refunds : Codable {
    let object : String?
    let data : [String]?
    let has_more : Bool?
    let total_count : Int?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case object = "object"
        case data = "data"
        case has_more = "has_more"
        case total_count = "total_count"
        case url = "url"
    }}

struct Source : Codable {
    let id : String?
    let object : String?
    let address_city : String?
    let address_country : String?
    let address_line1 : String?
    let address_line1_check : String?
    let address_line2 : String?
    let address_state : String?
    let address_zip : String?
    let address_zip_check : String?
    let brand : String?
    let country : String?
    let customer : String?
    let cvc_check : String?
    let dynamic_last4 : String?
    let exp_month : Int?
    let exp_year : Int?
    let fingerprint : String?
    let funding : String?
    let last4 : String?
    let metadata : Metadata?
    let name : String?
    let tokenization_method : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case object = "object"
        case address_city = "address_city"
        case address_country = "address_country"
        case address_line1 = "address_line1"
        case address_line1_check = "address_line1_check"
        case address_line2 = "address_line2"
        case address_state = "address_state"
        case address_zip = "address_zip"
        case address_zip_check = "address_zip_check"
        case brand = "brand"
        case country = "country"
        case customer = "customer"
        case cvc_check = "cvc_check"
        case dynamic_last4 = "dynamic_last4"
        case exp_month = "exp_month"
        case exp_year = "exp_year"
        case fingerprint = "fingerprint"
        case funding = "funding"
        case last4 = "last4"
        case metadata = "metadata"
        case name = "name"
        case tokenization_method = "tokenization_method"
    }
}

struct Address : Codable {
    let city : String?
    let country : String?
    let line1 : String?
    let line2 : String?
    let postal_code : String?
    let state : String?

    enum CodingKeys: String, CodingKey {

        case city = "city"
        case country = "country"
        case line1 = "line1"
        case line2 = "line2"
        case postal_code = "postal_code"
        case state = "state"
    }}

struct Card : Codable {
    let brand : String?
    let checks : Checks?
    let country : String?
    let exp_month : Int?
    let exp_year : Int?
    let fingerprint : String?
    let funding : String?
    let installments : String?
    let last4 : String?
    let network : String?
    let three_d_secure : String?
    let wallet : String?

    enum CodingKeys: String, CodingKey {

        case brand = "brand"
        case checks = "checks"
        case country = "country"
        case exp_month = "exp_month"
        case exp_year = "exp_year"
        case fingerprint = "fingerprint"
        case funding = "funding"
        case installments = "installments"
        case last4 = "last4"
        case network = "network"
        case three_d_secure = "three_d_secure"
        case wallet = "wallet"
    }
}

struct Checks : Codable {
    let address_line1_check : String?
    let address_postal_code_check : String?
    let cvc_check : String?

    enum CodingKeys: String, CodingKey {

        case address_line1_check = "address_line1_check"
        case address_postal_code_check = "address_postal_code_check"
        case cvc_check = "cvc_check"
    }
}
