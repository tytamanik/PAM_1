import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverter(),
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

      if (fromCurrency == 'MDL') {
        exchangeRate = 0.05;
      } else {
        exchangeRate = 1 / 0.05;
      }
      _exchangeRateController.text = exchangeRate.toStringAsFixed(2);
    });
  }

  void _convertCurrency() {
    setState(() {
      if (fromCurrency == 'MDL') {
        toAmount = fromAmount * exchangeRate;
      } else {
        toAmount = fromAmount / exchangeRate;
      }
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
        toolbarHeight: 80.0,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
              color: Color.fromARGB(255, 7, 39, 87),
              fontWeight: FontWeight.w700),
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
            _buildExchangeRateInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              _buildCurrencyInput(
                  fromCurrency, _fromAmountController, 'Amount'),
              const SizedBox(height: 10.0),
              Divider(thickness: 1, color: Colors.grey[300]),
              const SizedBox(height: 10.0),
              _buildCurrencyInput(
                  toCurrency,
                  TextEditingController(text: toAmount.toStringAsFixed(2)),
                  'Converted Amount'),
            ],
          ),
        ),
        _buildSwapButton(),
      ],
    );
  }

  Widget _buildCurrencyInput(
      String currency, TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
        const SizedBox(height: 5.0),
        Row(
          children: [
            DropdownButton<String>(
              value: currency,
              icon: const Icon(Icons.arrow_drop_down),
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/$value.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newCurrency) {
                setState(() {
                  if (label == 'Amount') {
                    fromCurrency = newCurrency!;
                  } else {
                    toCurrency = newCurrency!;
                  }
                  _convertCurrency();
                });
              },
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  border: InputBorder.none,
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

  Widget _buildSwapButton() {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.swap_vert, color: Colors.white),
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
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
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
