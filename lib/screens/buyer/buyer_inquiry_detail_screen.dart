import 'package:flutter/material.dart';
import '../../models/buyer_inquiry_model.dart';

class BuyerInquiryDetailScreen extends StatelessWidget {
  final BuyerInquiryModel inquiry;

  const BuyerInquiryDetailScreen({
    super.key,
    required this.inquiry,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepted = inquiry.status.toLowerCase() == "accepted";

    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAF7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Inquiry Details",
          style: TextStyle(
            color: Color(0xff0F5C3A),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _bottomButton(context, isAccepted),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cropCard(),
            const SizedBox(height: 18),
            _infoCard(),
            const SizedBox(height: 18),
            _messageCard(),
            const SizedBox(height: 18),
            _timelineCard(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _cropCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              inquiry.imageUrl,
              height: 86,
              width: 86,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.cropName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff10291D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  inquiry.farmerName,
                  style: const TextStyle(
                    color: Color(0xff5F675F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _statusChip(inquiry.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _detailRow("Quantity", inquiry.quantity),
          _detailRow("Offer Price", inquiry.offerPrice),
          _detailRow("Delivery Date", inquiry.deliveryDate),
          _detailRow("Inquiry Date", inquiry.date),
        ],
      ),
    );
  }

  Widget _messageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Buyer Message",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xff10291D),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            inquiry.message,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xff4E5A52),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard() {
    final status = inquiry.status.toLowerCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inquiry Timeline",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xff10291D),
            ),
          ),
          const SizedBox(height: 16),
          _timelineItem("Inquiry Sent", true),
          _timelineItem(
            "Farmer Response",
            status == "accepted" ||
                status == "declined" ||
                status == "rejected" ||
                status == "completed",
          ),
          _timelineItem(
            "Deal Completed",
            status == "completed",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(String title, bool completed, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed ? const Color(0xff0F5C3A) : Colors.grey,
              size: 22,
            ),
            if (!isLast)
              Container(
                height: 34,
                width: 2,
                color: completed ? const Color(0xff0F5C3A) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: completed ? const Color(0xff10291D) : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff6A756D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xff10291D),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bgColor = const Color(0xffE6ECE8);
    Color textColor = const Color(0xff4E6B59);

    if (status.toLowerCase() == "accepted") {
      bgColor = const Color(0xffA8F0C8);
      textColor = const Color(0xff0F5C3A);
    } else if (status.toLowerCase() == "declined" ||
        status.toLowerCase() == "rejected") {
      bgColor = const Color(0xffFFD6D6);
      textColor = Colors.red;
    } else if (status.toLowerCase() == "completed") {
      bgColor = const Color(0xffD7E8FF);
      textColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }

  Widget _bottomButton(BuildContext context, bool isAccepted) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isAccepted ? const Color(0xff0F5C3A) : Colors.white,
            side: const BorderSide(color: Color(0xff0F5C3A)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            isAccepted ? "Message Farmer" : "Back to Inquiries",
            style: TextStyle(
              color: isAccepted ? Colors.white : const Color(0xff0F5C3A),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xffDCE7DD)),
    );
  }
}