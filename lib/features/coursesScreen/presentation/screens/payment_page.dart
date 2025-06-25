import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/payment_bloc.dart';
// import 'package:skillwave/features/coursesScreen/presentation/bloc/payment_event.dart';
// import 'package:skillwave/features/coursesScreen/presentation/bloc/payment_state.dart';
import 'package:skillwave/config/di/di.container.dart';

class PaymentPage extends StatefulWidget {
  final int amount;
  final String courseId;
  final CourseEntity course;
  const PaymentPage({
    Key? key,
    required this.amount,
    required this.courseId,
    required this.course,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedMethod;

  void _confirmPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }
    if (_selectedMethod == 'PayPal') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AcnpbvL-nqay69eboBK-a2hcQLnkFTQZXbTF0f4UafVwhRYAXe11Z0B3PtFyWCTDH24INY6Cu2U0rhRC",
            secretKey:
                "EGZXWncK71BKAfqH7ClPpldekK6kSKvO9yIk0Loz36CkdM7uLC_vuE5mjbGjRhJhBT5BeOYyBB-_p6WW",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": widget.amount.toString(),
                  "currency": "USD",
                  "details": {
                    "subtotal": widget.amount.toString(),
                    "shipping": '0',
                    "shipping_discount": 0,
                  },
                },
                "description": "Payment for course: ${widget.course.title}",
                "item_list": {
                  "items": [
                    {
                      "name": widget.course.title,
                      "quantity": 1,
                      "price": widget.amount.toString(),
                      "currency": "USD",
                    },
                  ],
                },
              },
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              if (mounted) {
                // Dispatch payment event on PayPal success
              }
            },
            onError: (error) {
              if (mounted) {
                // BlocProvider.of<PaymentBloc>(context).add(
                //   CreatePayment(
                //     courseId: widget.courseId,
                //     amount: widget.amount,
                //     paymentMethod: 'PayPal',
                //     status: 'error',
                //   ),
                // );
              }
            },
            onCancel: (params) {
              if (mounted) {
                // BlocProvider.of<PaymentBloc>(context).add(
                //   CreatePayment(
                //     courseId: widget.courseId,
                //     amount: widget.amount,
                //     paymentMethod: 'PayPal',
                //     status: 'cancelled',
                //   ),
                // );
              }
            },
          ),
        ),
      );
      BlocProvider.of<PaymentBloc>(context).add(
        CreatePayment(
          courseId: widget.courseId,
          amount: widget.amount,
          paymentMethod: 'paypal',
          status: 'successful',
        ),
      );
    } else if (_selectedMethod == 'eSewa') {
      // TODO: Integrate eSewa payment and on success, dispatch event
      // For now, just dispatch event for demonstration
      BlocProvider.of<PaymentBloc>(context).add(
        CreatePayment(
          courseId: widget.courseId,
          amount: widget.amount,
          paymentMethod: 'eSewa',
          status: 'successful',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider<PaymentBloc>(
      create: (_) => getIt<PaymentBloc>(),
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.of(
              context,
              rootNavigator: true,
            ).popUntil((route) => route.isFirst || route.settings.name == null);
          }
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful!')),
            );
            Navigator.of(context).pop(true); // Return to previous page
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: ${state.failure.message}'),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
            backgroundColor: Colors.indigo.shade700,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Banner Image with Shadow
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        "http://10.0.2.2:3000/thumbnails/${widget.course.thumbnail}",
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Course Title
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                // Course Description
                Text(
                  widget.course.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Checkout Section with Summary
                _buildCheckoutSummary(),
                const SizedBox(height: 30),
                // Payment Options Header
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Payment Methods
                _buildPaymentMethod(
                  'eSewa',
                  'assets/icons/esewa.png',
                  'Pay via eSewa for quick transactions',
                  screenWidth,
                ),
                _buildPaymentMethod(
                  'PayPal',
                  'assets/icons/paypal.png',
                  'Secure global payment through PayPal',
                  screenWidth,
                ),
                const SizedBox(height: 30),
                // Confirm Payment Button with Elevated Style
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      shadowColor: Colors.blueAccent.shade700.withOpacity(0.3),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Confirm Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkout Summary',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Course Price:', style: TextStyle(fontSize: 18)),
              Text(
                'Npr.${widget.amount}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 20, color: Colors.black26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'Npr.${widget.amount}',
                style: const TextStyle(fontSize: 22, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String method,
    String iconPath,
    String description,
    double screenWidth,
  ) {
    final isSelected = _selectedMethod == method;
    return Card(
      elevation: isSelected ? 10 : 4,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: ListTile(
        leading: Image.asset(
          iconPath,
          width: screenWidth * 0.09,
          height: screenWidth * 0.09,
        ),
        title: Text(
          method,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.blueAccent.shade700
                : Colors.deepPurpleAccent,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: screenWidth * 0.04,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: $method'),
              backgroundColor: Colors.deepPurpleAccent,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        tileColor: isSelected ? Colors.blue.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? Colors.blueAccent.shade700 : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
      ),
    );
  }
}
