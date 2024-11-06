import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String fromCurrency = 'MDL';
  String toCurrency = 'USD';
  double fromAmount = 1000.0;
  double toAmount = 200.0;
  double exchangeRate = 0.05;

  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();

  List<String> currencies = ['MDL', 'USD', 'EUR', 'GBP'];

  Map<String, String> currencyFlags = {
    'MDL': 'assets/mdl.svg',
    'USD': 'assets/usd.svg',
    'EUR': 'assets/eur.svg',
    'GBP': 'assets/gbp.svg',
  };

  @override
  void initState() {
    super.initState();
    _fromAmountController.text = fromAmount.toStringAsFixed(2);
    _exchangeRateController.text = exchangeRate.toString();
  }

  void _swapCurrencies() {
    setState(() {
      String tempCurrency = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = tempCurrency;

      _convertCurrency();
    });
  }

  void _convertCurrency() {
    setState(() {
      if (fromCurrency == 'MDL' && toCurrency == 'USD') {
        exchangeRate = 0.05;
      } else if (fromCurrency == 'USD' && toCurrency == 'MDL') {
        exchangeRate = 1 / 0.05;
      }

      toAmount = fromAmount * exchangeRate;
      _exchangeRateController.text = exchangeRate.toStringAsFixed(2);
    });
  }

  void _handleExchangeRateInput(String value) {
    String formattedValue = value.replaceAll(',', '.');
    setState(() {
      exchangeRate = double.tryParse(formattedValue) ?? exchangeRate;
      _convertCurrency();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        toolbarHeight: 100.0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
              color: Color.fromRGBO(38, 39, 141, 1),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrencyContainer(),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            _buildExchangeRateInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyContainer() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 5.0),
              _buildCurrencyInput(
                  fromCurrency, _fromAmountController, 'Amount'),
              const SizedBox(height: 30.0),
              Divider(thickness: 1, color: Colors.grey[300]),
              const SizedBox(height: 30.0),
              _buildCurrencyInput(
                toCurrency,
                TextEditingController(text: toAmount.toStringAsFixed(2)),
                'Converted amount',
              ),
              const SizedBox(height: 5.0),
            ],
          ),
          Positioned(
            top: 90.0,
            child: _buildSwapButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyInput(
      String currency, TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            _buildCurrencyDropdown(currency),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    fromAmount = double.tryParse(value) ?? 0;
                    _convertCurrency();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown(String currency) {
    return DropdownButton<String>(
      value: currency,
      icon: Icon(
        CupertinoIcons.chevron_down,
        size: 16,
        color: Colors.grey[700],
      ),
      underline: Container(),
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            if (currency == fromCurrency) {
              fromCurrency = newValue;
            } else {
              toCurrency = newValue;
            }
            _convertCurrency();
          }
        });
      },
      items: currencies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              SvgPicture.asset(
                currencyFlags[value]!,
                width: 30.0,
              ),
              const SizedBox(width: 8.0),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwapButton() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(38, 39, 141, 1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_up_arrow_down,
            color: Colors.white,
            size: 18,
          ),
          onPressed: _swapCurrencies,
        ),
      ),
    );
  }

  Widget _buildExchangeRateInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('1 $fromCurrency = '),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 80.0,
              child: TextFormField(
                controller: _exchangeRateController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _handleExchangeRateInput(value);
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Text(toCurrency),
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          'Indicative Exchange Rate',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
