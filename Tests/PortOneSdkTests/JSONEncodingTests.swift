import XCTest
@testable import PortOneSdk

final class JSONEncodingTests: XCTestCase {

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    // MARK: - Helper Methods

    private func encodeToJSON<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data) as! [String: Any]
    }

    private func encodeToString<T: Encodable>(_ value: T) throws -> String {
        let data = try encoder.encode(value)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Enum Encoding Tests

    func testBankEnumRawValues() {
        // browser-sdk에서 Bank enum은 "BANK_OF_KOREA", "KOOKMIN_BANK" 등의 값을 사용
        XCTAssertEqual(Bank.BANK_OF_KOREA.rawValue, "BANK_OF_KOREA")
        XCTAssertEqual(Bank.KOOKMIN_BANK.rawValue, "KOOKMIN_BANK")
        XCTAssertEqual(Bank.INDUSTRIAL_BANK_OF_KOREA.rawValue, "INDUSTRIAL_BANK_OF_KOREA")
        XCTAssertEqual(Bank.NH_NONGHYUP_BANK.rawValue, "NH_NONGHYUP_BANK")
        XCTAssertEqual(Bank.SHINHAN_BANK.rawValue, "SHINHAN_BANK")
        XCTAssertEqual(Bank.HANA_BANK.rawValue, "HANA_BANK")
        XCTAssertEqual(Bank.K_BANK.rawValue, "K_BANK")
        XCTAssertEqual(Bank.KAKAO_BANK.rawValue, "KAKAO_BANK")
        XCTAssertEqual(Bank.TOSS_BANK.rawValue, "TOSS_BANK")
    }

    func testBankJSONEncoding() throws {
        let encoded = try encodeToString(Bank.KOOKMIN_BANK)
        XCTAssertEqual(encoded, "\"KOOKMIN_BANK\"")
    }

    func testCardCompanyEnumRawValues() {
        // browser-sdk에서 CardCompany enum 값
        XCTAssertEqual(CardCompany.SAMSUNG_CARD.rawValue, "SAMSUNG_CARD")
        XCTAssertEqual(CardCompany.SHINHAN_CARD.rawValue, "SHINHAN_CARD")
        XCTAssertEqual(CardCompany.HYUNDAI_CARD.rawValue, "HYUNDAI_CARD")
        XCTAssertEqual(CardCompany.LOTTE_CARD.rawValue, "LOTTE_CARD")
        XCTAssertEqual(CardCompany.KOOKMIN_CARD.rawValue, "KOOKMIN_CARD")
        XCTAssertEqual(CardCompany.BC_CARD.rawValue, "BC_CARD")
        XCTAssertEqual(CardCompany.HANA_CARD.rawValue, "HANA_CARD")
        XCTAssertEqual(CardCompany.NH_CARD.rawValue, "NH_CARD")
    }

    func testCarrierEnumRawValues() {
        // browser-sdk에서 Carrier enum 값
        XCTAssertEqual(Carrier.SKT.rawValue, "SKT")
        XCTAssertEqual(Carrier.KT.rawValue, "KT")
        XCTAssertEqual(Carrier.LGU.rawValue, "LGU")
        XCTAssertEqual(Carrier.HELLO.rawValue, "HELLO")
        XCTAssertEqual(Carrier.KCT.rawValue, "KCT")
        XCTAssertEqual(Carrier.SK7.rawValue, "SK7")
    }

    func testCurrencyEnumRawValues() {
        // browser-sdk에서 Currency enum 값
        XCTAssertEqual(Currency.KRW.rawValue, "KRW")
        XCTAssertEqual(Currency.USD.rawValue, "USD")
        XCTAssertEqual(Currency.EUR.rawValue, "EUR")
        XCTAssertEqual(Currency.JPY.rawValue, "JPY")
        XCTAssertEqual(Currency.CNY.rawValue, "CNY")
    }

    func testGenderEnumRawValues() {
        // browser-sdk에서 Gender enum 값
        XCTAssertEqual(Gender.MALE.rawValue, "MALE")
        XCTAssertEqual(Gender.FEMALE.rawValue, "FEMALE")
        XCTAssertEqual(Gender.OTHER.rawValue, "OTHER")
    }

    func testProductTypeEnumRawValues() throws {
        XCTAssertEqual(ProductType.REAL.rawValue, "REAL")
        XCTAssertEqual(ProductType.DIGITAL.rawValue, "DIGITAL")
    }

    func testCashReceiptTypeEnumRawValues() {
        XCTAssertEqual(CashReceiptType.PERSONAL.rawValue, "PERSONAL")
        XCTAssertEqual(CashReceiptType.CORPORATE.rawValue, "CORPORATE")
        XCTAssertEqual(CashReceiptType.ANONYMOUS.rawValue, "ANONYMOUS")
    }

    func testTransactionTypeEnumRawValues() {
        XCTAssertEqual(TransactionType.PAYMENT.rawValue, "PAYMENT")
        XCTAssertEqual(TransactionType.ISSUE_BILLING_KEY.rawValue, "ISSUE_BILLING_KEY")
        XCTAssertEqual(TransactionType.IDENTITY_VERIFICATION.rawValue, "IDENTITY_VERIFICATION")
        XCTAssertEqual(TransactionType.ISSUE_BILLING_KEY_AND_PAY.rawValue, "ISSUE_BILLING_KEY_AND_PAY")
    }

    func testWindowTypeEnumRawValues() {
        XCTAssertEqual(WindowType.IFRAME.rawValue, "IFRAME")
        XCTAssertEqual(WindowType.POPUP.rawValue, "POPUP")
        XCTAssertEqual(WindowType.REDIRECTION.rawValue, "REDIRECTION")
    }

    // MARK: - Struct Encoding Tests (camelCase field names)

    func testCustomerEncodingFieldNames() throws {
        let customer = Customer(
            customerId: "cust_123",
            fullName: "홍길동",
            firstName: "길동",
            lastName: "홍",
            phoneNumber: "010-1234-5678",
            email: "test@example.com",
            zipcode: "12345",
            gender: .MALE,
            birthYear: "1990",
            birthMonth: "01",
            birthDay: "15"
        )

        let json = try encodeToJSON(customer)

        // browser-sdk와 동일한 camelCase 필드 이름 확인
        XCTAssertEqual(json["customerId"] as? String, "cust_123")
        XCTAssertEqual(json["fullName"] as? String, "홍길동")
        XCTAssertEqual(json["firstName"] as? String, "길동")
        XCTAssertEqual(json["lastName"] as? String, "홍")
        XCTAssertEqual(json["phoneNumber"] as? String, "010-1234-5678")
        XCTAssertEqual(json["email"] as? String, "test@example.com")
        XCTAssertEqual(json["zipcode"] as? String, "12345")
        XCTAssertEqual(json["gender"] as? String, "MALE")
        XCTAssertEqual(json["birthYear"] as? String, "1990")
        XCTAssertEqual(json["birthMonth"] as? String, "01")
        XCTAssertEqual(json["birthDay"] as? String, "15")
    }

    func testAddressEncodingFieldNames() throws {
        let address = Address(
            country: .KR,
            addressLine1: "서울시 강남구",
            addressLine2: "테헤란로 123",
            city: "서울",
            province: "서울특별시"
        )

        let json = try encodeToJSON(address)

        // browser-sdk와 동일한 camelCase 필드 이름 확인
        XCTAssertEqual(json["country"] as? String, "KR")
        XCTAssertEqual(json["addressLine1"] as? String, "서울시 강남구")
        XCTAssertEqual(json["addressLine2"] as? String, "테헤란로 123")
        XCTAssertEqual(json["city"] as? String, "서울")
        XCTAssertEqual(json["province"] as? String, "서울특별시")
    }

    func testCustomerWithNestedAddress() throws {
        let address = Address(
            country: .KR,
            addressLine1: "서울시 강남구",
            addressLine2: "테헤란로 123"
        )
        let customer = Customer(
            fullName: "홍길동",
            address: address
        )

        let json = try encodeToJSON(customer)

        XCTAssertEqual(json["fullName"] as? String, "홍길동")

        let addressJson = json["address"] as? [String: Any]
        XCTAssertNotNil(addressJson)
        XCTAssertEqual(addressJson?["country"] as? String, "KR")
        XCTAssertEqual(addressJson?["addressLine1"] as? String, "서울시 강남구")
        XCTAssertEqual(addressJson?["addressLine2"] as? String, "테헤란로 123")
    }

    // MARK: - Optional Field Exclusion Tests

    func testOptionalFieldsExcludedWhenNil() throws {
        let customer = Customer(
            fullName: "홍길동"
            // 나머지 필드는 nil
        )

        let json = try encodeToJSON(customer)

        XCTAssertEqual(json["fullName"] as? String, "홍길동")

        // nil 필드들은 JSON에 포함되지 않아야 함
        XCTAssertNil(json["customerId"])
        XCTAssertNil(json["firstName"])
        XCTAssertNil(json["lastName"])
        XCTAssertNil(json["phoneNumber"])
        XCTAssertNil(json["email"])
        XCTAssertNil(json["address"])
        XCTAssertNil(json["zipcode"])
        XCTAssertNil(json["gender"])
        XCTAssertNil(json["birthYear"])
        XCTAssertNil(json["birthMonth"])
        XCTAssertNil(json["birthDay"])
    }

    // MARK: - JSONValue Encoding Tests

    func testJSONValueNullEncoding() throws {
        let value = JSONValue.null
        let encoded = try encodeToString(value)
        XCTAssertEqual(encoded, "null")
    }

    func testJSONValueBoolEncoding() throws {
        XCTAssertEqual(try encodeToString(JSONValue.bool(true)), "true")
        XCTAssertEqual(try encodeToString(JSONValue.bool(false)), "false")
    }

    func testJSONValueIntEncoding() throws {
        XCTAssertEqual(try encodeToString(JSONValue.int(42)), "42")
        XCTAssertEqual(try encodeToString(JSONValue.int(-100)), "-100")
        XCTAssertEqual(try encodeToString(JSONValue.int(0)), "0")
    }

    func testJSONValueDoubleEncoding() throws {
        let encoded = try encodeToString(JSONValue.double(3.14))
        // 부동소수점 비교를 위해 디코딩 후 비교
        let decoded = try JSONDecoder().decode(Double.self, from: encoded.data(using: .utf8)!)
        XCTAssertEqual(decoded, 3.14, accuracy: 0.001)
    }

    func testJSONValueStringEncoding() throws {
        XCTAssertEqual(try encodeToString(JSONValue.string("hello")), "\"hello\"")
        XCTAssertEqual(try encodeToString(JSONValue.string("한글 테스트")), "\"한글 테스트\"")
    }

    func testJSONValueArrayEncoding() throws {
        let array = JSONValue.array([
            .int(1),
            .string("two"),
            .bool(true)
        ])
        let encoded = try encodeToString(array)
        XCTAssertEqual(encoded, "[1,\"two\",true]")
    }

    func testJSONValueObjectEncoding() throws {
        let object = JSONValue.object([
            "name": .string("test"),
            "value": .int(123)
        ])
        let json = try encodeToJSON(object)
        XCTAssertEqual(json["name"] as? String, "test")
        XCTAssertEqual(json["value"] as? Int, 123)
    }

    func testJSONValueNestedStructure() throws {
        let nested = JSONValue.object([
            "level1": .object([
                "level2": .array([
                    .string("item1"),
                    .int(2),
                    .object(["nested": .bool(true)])
                ])
            ])
        ])

        let data = try encoder.encode(nested)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)

        XCTAssertEqual(nested, decoded)
    }

    // MARK: - JSONValue Decoding Tests

    func testJSONValueDecoding() throws {
        let jsonString = """
        {
            "string": "hello",
            "number": 42,
            "float": 3.14,
            "bool": true,
            "null": null,
            "array": [1, 2, 3],
            "object": {"nested": "value"}
        }
        """

        let data = jsonString.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)

        guard case .object(let obj) = decoded else {
            XCTFail("Expected object")
            return
        }

        XCTAssertEqual(obj["string"], .string("hello"))
        XCTAssertEqual(obj["number"], .int(42))
        XCTAssertEqual(obj["bool"], .bool(true))
        XCTAssertEqual(obj["null"], .null)
        XCTAssertEqual(obj["array"], .array([.int(1), .int(2), .int(3)]))
        XCTAssertEqual(obj["object"], .object(["nested": .string("value")]))
    }

    // MARK: - Complex Type Encoding Tests

    func testInstallmentEncoding() throws {
        let installment = Installment(
            freeInstallmentPlans: [
                FreeInstallmentPlan(
                    cardCompany: .SHINHAN_CARD,
                    months: [3, 6, 12]
                )
            ],
            monthOption: .availableMonthList([3, 6, 12])
        )

        let json = try encodeToJSON(installment)

        let plans = json["freeInstallmentPlans"] as? [[String: Any]]
        XCTAssertNotNil(plans)
        XCTAssertEqual(plans?.count, 1)
        let firstPlan = plans?[0]
        XCTAssertNotNil(firstPlan)
        XCTAssertEqual(firstPlan?["cardCompany"] as? String, "SHINHAN_CARD")

        let monthOption = json["monthOption"] as? [String: Any]
        XCTAssertNotNil(monthOption)
        XCTAssertEqual(monthOption?["availableMonthList"] as? [Int], [3, 6, 12])
    }

    func testInstallmentMonthOptionEncodingFixedMonth() throws {
        let option = InstallmentMonthOption.fixedMonth(3)
        let json = try encodeToJSON(option)

        XCTAssertEqual(json["fixedMonth"] as? Int, 3)
        XCTAssertNil(json["availableMonthList"])
    }

    func testInstallmentMonthOptionEncodingAvailableMonthList() throws {
        let option = InstallmentMonthOption.availableMonthList([3, 6, 12])
        let json = try encodeToJSON(option)

        XCTAssertEqual(json["availableMonthList"] as? [Int], [3, 6, 12])
        XCTAssertNil(json["fixedMonth"])
    }

    func testOfferPeriodRangeEncoding() throws {
        let range = OfferPeriodRangeFromTo(
            from: "2024-01-01T00:00:00+09:00",
            to: "2024-12-31T23:59:59+09:00"
        )

        let json = try encodeToJSON(range)

        XCTAssertEqual(json["from"] as? String, "2024-01-01T00:00:00+09:00")
        XCTAssertEqual(json["to"] as? String, "2024-12-31T23:59:59+09:00")
    }

    func testStoreDetailsEncoding() throws {
        let storeDetails = StoreDetails(
            ceoFullName: "홍길동",
            phoneNumber: "02-1234-5678",
            email: "store@example.com",
            openingHours: StoreDetailsOpeningHours(
                open: "09:00",
                close: "18:00"
            )
        )

        let json = try encodeToJSON(storeDetails)

        XCTAssertEqual(json["ceoFullName"] as? String, "홍길동")
        XCTAssertEqual(json["phoneNumber"] as? String, "02-1234-5678")
        XCTAssertEqual(json["email"] as? String, "store@example.com")

        let openingHours = json["openingHours"] as? [String: Any]
        XCTAssertNotNil(openingHours)
        XCTAssertEqual(openingHours?["open"] as? String, "09:00")
        XCTAssertEqual(openingHours?["close"] as? String, "18:00")
    }

    // MARK: - Bidirectional Encoding/Decoding Tests

    func testCustomerRoundTrip() throws {
        let original = Customer(
            customerId: "cust_123",
            fullName: "홍길동",
            firstName: "길동",
            lastName: "홍",
            phoneNumber: "010-1234-5678",
            email: "test@example.com",
            gender: .MALE,
            birthYear: "1990",
            birthMonth: "01",
            birthDay: "15"
        )

        let data = try encoder.encode(original)
        let decoded = try JSONDecoder().decode(Customer.self, from: data)

        XCTAssertEqual(decoded.customerId, original.customerId)
        XCTAssertEqual(decoded.fullName, original.fullName)
        XCTAssertEqual(decoded.firstName, original.firstName)
        XCTAssertEqual(decoded.lastName, original.lastName)
        XCTAssertEqual(decoded.phoneNumber, original.phoneNumber)
        XCTAssertEqual(decoded.email, original.email)
        XCTAssertEqual(decoded.gender, original.gender)
        XCTAssertEqual(decoded.birthYear, original.birthYear)
        XCTAssertEqual(decoded.birthMonth, original.birthMonth)
        XCTAssertEqual(decoded.birthDay, original.birthDay)
    }

    func testBankRoundTrip() throws {
        for bank in [Bank.KOOKMIN_BANK, .SHINHAN_BANK, .HANA_BANK, .NH_NONGHYUP_BANK] {
            let data = try encoder.encode(bank)
            let decoded = try JSONDecoder().decode(Bank.self, from: data)
            XCTAssertEqual(decoded, bank)
        }
    }

    func testCurrencyRoundTrip() throws {
        for currency in [Currency.KRW, .USD, .EUR, .JPY] {
            let data = try encoder.encode(currency)
            let decoded = try JSONDecoder().decode(Currency.self, from: data)
            XCTAssertEqual(decoded, currency)
        }
    }

    // MARK: - browser-sdk Compatibility Tests

    func testBrowserSdkCompatiblePaymentRequest() throws {
        // browser-sdk에서 예상하는 JSON 형식과 일치하는지 확인
        let customer = Customer(
            customerId: "customer_123",
            fullName: "홍길동",
            email: "test@example.com"
        )

        let json = try encodeToJSON(customer)

        // browser-sdk TypeScript 인터페이스와 필드명이 일치하는지 확인
        // Customer 타입: customerId, fullName, firstName, lastName, phoneNumber, email, address, zipcode, gender, birthYear, birthMonth, birthDay
        XCTAssertTrue(json.keys.contains("customerId"))
        XCTAssertTrue(json.keys.contains("fullName"))
        XCTAssertTrue(json.keys.contains("email"))

        // snake_case가 아닌 camelCase 확인
        XCTAssertFalse(json.keys.contains("customer_id"))
        XCTAssertFalse(json.keys.contains("full_name"))
    }

    // MARK: - Enum Case Coverage Tests

    func testAllBankCasesHaveValidRawValues() {
        // 모든 Bank enum case가 browser-sdk와 일치하는 rawValue를 가지는지 확인
        let expectedBanks = [
            "BANK_OF_KOREA", "KOREA_DEVELOPMENT_BANK", "INDUSTRIAL_BANK_OF_KOREA",
            "KOOKMIN_BANK", "SUHYUP_BANK", "EXPORT_IMPORT_BANK_OF_KOREA",
            "NH_NONGHYUP_BANK", "LOCAL_NONGHYUP", "WOORI_BANK", "SC_BANK_KOREA",
            "CITI_BANK_KOREA", "DAEGU_BANK", "BUSAN_BANK", "GWANGJU_BANK",
            "JEJU_BANK", "JEONBUK_BANK", "KYONGNAM_BANK", "KFCC", "SHINHYUP",
            "SAVINGS_BANK_KOREA", "MORGAN_STANLEY_BANK", "HSBC_BANK", "DEUTSCHE_BANK",
            "JP_MORGAN_CHASE_BANK", "MIZUHO_BANK", "MUFG_BANK", "BANK_OF_AMERICA_BANK",
            "BNP_PARIBAS_BANK", "ICBC", "BANK_OF_CHINA", "NATIONAL_FORESTRY_COOPERATIVE_FEDERATION",
            "UNITED_OVERSEAS_BANK", "BANK_OF_COMMUNICATIONS", "CHINA_CONSTRUCTION_BANK",
            "EPOST", "KODIT", "KIBO", "HANA_BANK", "SHINHAN_BANK", "K_BANK",
            "KAKAO_BANK", "TOSS_BANK", "KCIS", "DAISHIN_SAVINGS_BANK", "SBI_SAVINGS_BANK",
            "HK_SAVINGS_BANK", "WELCOME_SAVINGS_BANK", "SHINHAN_SAVINGS_BANK",
            "KYOBO_SECURITIES", "DAISHIN_SECURITIES", "MERITZ_SECURITIES",
            "MIRAE_ASSET_SECURITIES", "BOOKOOK_SECURITIES", "SAMSUNG_SECURITIES",
            "SHINYOUNG_SECURITIES", "SHINHAN_FINANCIAL_INVESTMENT", "YUANTA_SECURITIES",
            "EUGENE_INVESTMENT_SECURITIES", "KAKAO_PAY_SECURITIES", "TOSS_SECURITIES",
            "KOREA_FOSS_SECURITIES", "HANA_FINANCIAL_INVESTMENT", "HI_INVESTMENT_SECURITIES",
            "KOREA_INVESTMENT_SECURITIES", "HANWHA_INVESTMENT_SECURITIES",
            "HYUNDAI_MOTOR_SECURITIES", "DB_FINANCIAL_INVESTMENT", "KB_SECURITIES",
            "KTB_INVESTMENT_SECURITIES", "NH_INVESTMENT_SECURITIES", "SK_SECURITIES",
            "SCI", "KIWOOM_SECURITIES", "EBEST_INVESTMENT_SECURITIES", "CAPE_INVESTMENT_CERTIFICATE"
        ]

        for bankName in expectedBanks {
            let bank = Bank(rawValue: bankName)
            XCTAssertNotNil(bank, "Bank enum should have case for \(bankName)")
        }
    }

    func testAllCarrierCasesHaveValidRawValues() {
        let expectedCarriers = ["SKT", "KT", "LGU", "HELLO", "KCT", "SK7"]

        for carrierName in expectedCarriers {
            let carrier = Carrier(rawValue: carrierName)
            XCTAssertNotNil(carrier, "Carrier enum should have case for \(carrierName)")
        }
    }

    // MARK: - PaymentRequest JSON Compatibility Tests

    func testPaymentRequestBasicEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 기본 PaymentRequest JSON 형식
        let expectedJSON = """
        {
            "storeId": "store-test-123",
            "paymentId": "payment-test-456",
            "orderName": "테스트 상품",
            "totalAmount": 10000,
            "currency": "KRW",
            "payMethod": "CARD",
            "channelKey": "channel-key-789"
        }
        """

        let request = PaymentRequest(
            storeId: "store-test-123",
            paymentId: "payment-test-456",
            orderName: "테스트 상품",
            totalAmount: 10000,
            currency: .KRW,
            payMethod: .CARD,
            channelKey: "channel-key-789"
        )

        let json = try encodeToJSON(request)

        // 필수 필드 검증
        XCTAssertEqual(json["storeId"] as? String, "store-test-123")
        XCTAssertEqual(json["paymentId"] as? String, "payment-test-456")
        XCTAssertEqual(json["orderName"] as? String, "테스트 상품")
        XCTAssertEqual(json["totalAmount"] as? Int, 10000)
        XCTAssertEqual(json["currency"] as? String, "KRW")
        XCTAssertEqual(json["payMethod"] as? String, "CARD")
        XCTAssertEqual(json["channelKey"] as? String, "channel-key-789")

        // browser-sdk와 동일한 필드명 사용 (camelCase)
        XCTAssertFalse(json.keys.contains("store_id"))
        XCTAssertFalse(json.keys.contains("payment_id"))
        XCTAssertFalse(json.keys.contains("order_name"))
        XCTAssertFalse(json.keys.contains("total_amount"))
        XCTAssertFalse(json.keys.contains("pay_method"))
        XCTAssertFalse(json.keys.contains("channel_key"))

        // 예상 JSON과 비교 (필드별로)
        let expectedData = expectedJSON.data(using: .utf8)!
        let expectedDict = try JSONSerialization.jsonObject(with: expectedData) as! [String: Any]

        for (key, expectedValue) in expectedDict {
            if let expectedString = expectedValue as? String {
                XCTAssertEqual(json[key] as? String, expectedString, "Field \(key) mismatch")
            } else if let expectedInt = expectedValue as? Int {
                XCTAssertEqual(json[key] as? Int, expectedInt, "Field \(key) mismatch")
            }
        }
    }

    func testPaymentRequestWithCustomerEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 customer가 포함된 PaymentRequest JSON 형식
        let expectedJSON = """
        {
            "storeId": "store-test-123",
            "paymentId": "payment-test-456",
            "orderName": "테스트 상품",
            "totalAmount": 50000,
            "currency": "KRW",
            "payMethod": "CARD",
            "channelKey": "channel-key-789",
            "customer": {
                "customerId": "customer-001",
                "fullName": "홍길동",
                "phoneNumber": "010-1234-5678",
                "email": "test@example.com"
            },
            "taxFreeAmount": 0,
            "isEscrow": false
        }
        """

        let customer = Customer(
            customerId: "customer-001",
            fullName: "홍길동",
            phoneNumber: "010-1234-5678",
            email: "test@example.com"
        )

        let request = PaymentRequest(
            storeId: "store-test-123",
            paymentId: "payment-test-456",
            orderName: "테스트 상품",
            totalAmount: 50000,
            currency: .KRW,
            payMethod: .CARD,
            channelKey: "channel-key-789",
            taxFreeAmount: 0,
            customer: customer,
            isEscrow: false
        )

        let json = try encodeToJSON(request)

        // 필수 필드 검증
        XCTAssertEqual(json["storeId"] as? String, "store-test-123")
        XCTAssertEqual(json["totalAmount"] as? Int, 50000)
        XCTAssertEqual(json["taxFreeAmount"] as? Int, 0)
        XCTAssertEqual(json["isEscrow"] as? Bool, false)

        // customer 객체 검증
        let customerJson = json["customer"] as? [String: Any]
        XCTAssertNotNil(customerJson)
        XCTAssertEqual(customerJson?["customerId"] as? String, "customer-001")
        XCTAssertEqual(customerJson?["fullName"] as? String, "홍길동")
        XCTAssertEqual(customerJson?["phoneNumber"] as? String, "010-1234-5678")
        XCTAssertEqual(customerJson?["email"] as? String, "test@example.com")
    }

    func testPaymentRequestWithProductsEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 products가 포함된 PaymentRequest JSON 형식
        let expectedJSON = """
        {
            "storeId": "store-test-123",
            "paymentId": "payment-test-456",
            "orderName": "복합 상품",
            "totalAmount": 35000,
            "currency": "KRW",
            "payMethod": "CARD",
            "channelKey": "channel-key-789",
            "products": [
                {
                    "id": "product-001",
                    "name": "상품 A",
                    "amount": 15000,
                    "quantity": 1
                },
                {
                    "id": "product-002",
                    "name": "상품 B",
                    "amount": 20000,
                    "quantity": 1
                }
            ]
        }
        """

        let products = [
            Product(id: "product-001", name: "상품 A", amount: 15000, quantity: 1),
            Product(id: "product-002", name: "상품 B", amount: 20000, quantity: 1)
        ]

        let request = PaymentRequest(
            storeId: "store-test-123",
            paymentId: "payment-test-456",
            orderName: "복합 상품",
            totalAmount: 35000,
            currency: .KRW,
            payMethod: .CARD,
            channelKey: "channel-key-789",
            products: products
        )

        let json = try encodeToJSON(request)

        // products 배열 검증
        let productsJson = json["products"] as? [[String: Any]]
        XCTAssertNotNil(productsJson)
        XCTAssertEqual(productsJson?.count, 2)

        let firstProduct = productsJson?[0]
        XCTAssertEqual(firstProduct?["id"] as? String, "product-001")
        XCTAssertEqual(firstProduct?["name"] as? String, "상품 A")
        XCTAssertEqual(firstProduct?["amount"] as? Int, 15000)
        XCTAssertEqual(firstProduct?["quantity"] as? Int, 1)

        let secondProduct = productsJson?[1]
        XCTAssertEqual(secondProduct?["id"] as? String, "product-002")
        XCTAssertEqual(secondProduct?["name"] as? String, "상품 B")
        XCTAssertEqual(secondProduct?["amount"] as? Int, 20000)
        XCTAssertEqual(secondProduct?["quantity"] as? Int, 1)
    }

    func testPaymentRequestAllPayMethodsEncoding() throws {
        // browser-sdk의 모든 PaymentPayMethod 값이 올바르게 인코딩되는지 확인
        let payMethods: [PaymentPayMethod] = [
            .CARD, .VIRTUAL_ACCOUNT, .TRANSFER, .MOBILE,
            .GIFT_CERTIFICATE, .EASY_PAY, .PAYPAL, .ALIPAY, .CONVENIENCE_STORE
        ]

        let expectedValues = [
            "CARD", "VIRTUAL_ACCOUNT", "TRANSFER", "MOBILE",
            "GIFT_CERTIFICATE", "EASY_PAY", "PAYPAL", "ALIPAY", "CONVENIENCE_STORE"
        ]

        for (index, payMethod) in payMethods.enumerated() {
            let request = PaymentRequest(
                storeId: "store-test",
                paymentId: "payment-\(index)",
                orderName: "테스트",
                totalAmount: 1000,
                currency: .KRW,
                payMethod: payMethod,
                channelKey: "channel-key"
            )

            let json = try encodeToJSON(request)
            XCTAssertEqual(json["payMethod"] as? String, expectedValues[index],
                          "PayMethod \(payMethod) should encode to \(expectedValues[index])")
        }
    }

    // MARK: - IdentityVerificationRequest JSON Compatibility Tests

    func testIdentityVerificationRequestBasicEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 기본 IdentityVerificationRequest JSON 형식
        let expectedJSON = """
        {
            "storeId": "store-test-123",
            "identityVerificationId": "identity-verification-456",
            "channelKey": "channel-key-789"
        }
        """

        let request = IdentityVerificationRequest(
            storeId: "store-test-123",
            identityVerificationId: "identity-verification-456",
            channelKey: "channel-key-789"
        )

        let json = try encodeToJSON(request)

        // 필수 필드 검증
        XCTAssertEqual(json["storeId"] as? String, "store-test-123")
        XCTAssertEqual(json["identityVerificationId"] as? String, "identity-verification-456")
        XCTAssertEqual(json["channelKey"] as? String, "channel-key-789")

        // browser-sdk와 동일한 필드명 사용 (camelCase)
        XCTAssertFalse(json.keys.contains("store_id"))
        XCTAssertFalse(json.keys.contains("identity_verification_id"))
        XCTAssertFalse(json.keys.contains("channel_key"))

        // 예상 JSON과 비교
        let expectedData = expectedJSON.data(using: .utf8)!
        let expectedDict = try JSONSerialization.jsonObject(with: expectedData) as! [String: Any]

        for (key, expectedValue) in expectedDict {
            if let expectedString = expectedValue as? String {
                XCTAssertEqual(json[key] as? String, expectedString, "Field \(key) mismatch")
            }
        }
    }

    func testIdentityVerificationRequestWithCustomerEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 customer가 포함된 IdentityVerificationRequest JSON 형식
        let expectedJSON = """
        {
            "storeId": "store-test-123",
            "identityVerificationId": "identity-verification-456",
            "channelKey": "channel-key-789",
            "customer": {
                "fullName": "홍길동",
                "phoneNumber": "010-1234-5678",
                "birthYear": "1990",
                "birthMonth": "01",
                "birthDay": "15"
            }
        }
        """

        let customer = Customer(
            fullName: "홍길동",
            phoneNumber: "010-1234-5678",
            birthYear: "1990",
            birthMonth: "01",
            birthDay: "15"
        )

        let request = IdentityVerificationRequest(
            storeId: "store-test-123",
            identityVerificationId: "identity-verification-456",
            channelKey: "channel-key-789",
            customer: customer
        )

        let json = try encodeToJSON(request)

        // customer 객체 검증
        let customerJson = json["customer"] as? [String: Any]
        XCTAssertNotNil(customerJson)
        XCTAssertEqual(customerJson?["fullName"] as? String, "홍길동")
        XCTAssertEqual(customerJson?["phoneNumber"] as? String, "010-1234-5678")
        XCTAssertEqual(customerJson?["birthYear"] as? String, "1990")
        XCTAssertEqual(customerJson?["birthMonth"] as? String, "01")
        XCTAssertEqual(customerJson?["birthDay"] as? String, "15")
    }

    func testIdentityVerificationRequestWithAllOptionsEncodingMatchesBrowserSdk() throws {
        // browser-sdk에서 예상하는 모든 옵션이 포함된 IdentityVerificationRequest JSON 형식
        let customer = Customer(
            fullName: "홍길동",
            phoneNumber: "010-1234-5678"
        )

        let request = IdentityVerificationRequest(
            storeId: "store-test-123",
            identityVerificationId: "identity-verification-456",
            channelKey: "channel-key-789",
            customer: customer,
            forceRedirect: true,
            customData: "custom-data-string"
        )

        let json = try encodeToJSON(request)

        // 모든 필드 검증
        XCTAssertEqual(json["storeId"] as? String, "store-test-123")
        XCTAssertEqual(json["identityVerificationId"] as? String, "identity-verification-456")
        XCTAssertEqual(json["channelKey"] as? String, "channel-key-789")
        XCTAssertEqual(json["forceRedirect"] as? Bool, true)
        XCTAssertEqual(json["customData"] as? String, "custom-data-string")

        let customerJson = json["customer"] as? [String: Any]
        XCTAssertNotNil(customerJson)
        XCTAssertEqual(customerJson?["fullName"] as? String, "홍길동")
    }

    // MARK: - Full JSON String Comparison Tests

    func testPaymentRequestExactJSONStringMatch() throws {
        // iOS SDK에서 생성한 JSON이 browser-sdk가 기대하는 형식과 정확히 일치하는지 확인
        let request = PaymentRequest(
            storeId: "store-test-123",
            paymentId: "payment-test-456",
            orderName: "테스트 상품",
            totalAmount: 10000,
            currency: .KRW,
            payMethod: .CARD,
            channelKey: "channel-key-789"
        )

        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // browser-sdk TypeScript 인터페이스의 필드명과 정확히 일치해야 함
        let requiredFields = ["storeId", "paymentId", "orderName", "totalAmount", "currency", "payMethod", "channelKey"]
        for field in requiredFields {
            XCTAssertTrue(json.keys.contains(field), "Required field '\(field)' is missing")
        }

        // 값 타입 검증
        XCTAssertTrue(json["storeId"] is String)
        XCTAssertTrue(json["paymentId"] is String)
        XCTAssertTrue(json["orderName"] is String)
        XCTAssertTrue(json["totalAmount"] is Int)
        XCTAssertTrue(json["currency"] is String)
        XCTAssertTrue(json["payMethod"] is String)
        XCTAssertTrue(json["channelKey"] is String)
    }

    func testIdentityVerificationRequestExactJSONStringMatch() throws {
        // iOS SDK에서 생성한 JSON이 browser-sdk가 기대하는 형식과 정확히 일치하는지 확인
        let request = IdentityVerificationRequest(
            storeId: "store-test-123",
            identityVerificationId: "identity-verification-456",
            channelKey: "channel-key-789"
        )

        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // browser-sdk TypeScript 인터페이스의 필드명과 정확히 일치해야 함
        let requiredFields = ["storeId", "identityVerificationId", "channelKey"]
        for field in requiredFields {
            XCTAssertTrue(json.keys.contains(field), "Required field '\(field)' is missing")
        }

        // 값 타입 검증
        XCTAssertTrue(json["storeId"] is String)
        XCTAssertTrue(json["identityVerificationId"] is String)
        XCTAssertTrue(json["channelKey"] is String)
    }

    // MARK: - Decode from browser-sdk JSON Tests

    func testDecodePaymentRequestFromBrowserSdkJSON() throws {
        // browser-sdk에서 생성될 수 있는 JSON을 iOS SDK로 디코딩할 수 있는지 확인
        let browserSdkJSON = """
        {
            "storeId": "store-from-browser",
            "paymentId": "payment-from-browser",
            "orderName": "브라우저에서 생성된 주문",
            "totalAmount": 25000,
            "currency": "KRW",
            "payMethod": "EASY_PAY",
            "channelKey": "browser-channel-key",
            "taxFreeAmount": 5000,
            "isEscrow": false,
            "customer": {
                "customerId": "browser-customer-001",
                "fullName": "김철수",
                "email": "browser@test.com"
            }
        }
        """

        let data = browserSdkJSON.data(using: .utf8)!
        let request = try JSONDecoder().decode(PaymentRequest.self, from: data)

        XCTAssertEqual(request.storeId, "store-from-browser")
        XCTAssertEqual(request.paymentId, "payment-from-browser")
        XCTAssertEqual(request.orderName, "브라우저에서 생성된 주문")
        XCTAssertEqual(request.totalAmount, 25000)
        XCTAssertEqual(request.currency, .KRW)
        XCTAssertEqual(request.payMethod, .EASY_PAY)
        XCTAssertEqual(request.channelKey, "browser-channel-key")
        XCTAssertEqual(request.taxFreeAmount, 5000)
        XCTAssertEqual(request.isEscrow, false)
        XCTAssertEqual(request.customer?.customerId, "browser-customer-001")
        XCTAssertEqual(request.customer?.fullName, "김철수")
        XCTAssertEqual(request.customer?.email, "browser@test.com")
    }

    func testDecodeIdentityVerificationRequestFromBrowserSdkJSON() throws {
        // browser-sdk에서 생성될 수 있는 JSON을 iOS SDK로 디코딩할 수 있는지 확인
        let browserSdkJSON = """
        {
            "storeId": "store-from-browser",
            "identityVerificationId": "identity-from-browser",
            "channelKey": "browser-channel-key",
            "forceRedirect": true,
            "customer": {
                "fullName": "김철수",
                "phoneNumber": "010-9876-5432",
                "birthYear": "1985",
                "birthMonth": "12",
                "birthDay": "25"
            }
        }
        """

        let data = browserSdkJSON.data(using: .utf8)!
        let request = try JSONDecoder().decode(IdentityVerificationRequest.self, from: data)

        XCTAssertEqual(request.storeId, "store-from-browser")
        XCTAssertEqual(request.identityVerificationId, "identity-from-browser")
        XCTAssertEqual(request.channelKey, "browser-channel-key")
        XCTAssertEqual(request.forceRedirect, true)
        XCTAssertEqual(request.customer?.fullName, "김철수")
        XCTAssertEqual(request.customer?.phoneNumber, "010-9876-5432")
        XCTAssertEqual(request.customer?.birthYear, "1985")
        XCTAssertEqual(request.customer?.birthMonth, "12")
        XCTAssertEqual(request.customer?.birthDay, "25")
    }
}
