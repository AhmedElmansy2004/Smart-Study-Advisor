import google.generativeai as genai
import os
from django.conf import settings

CHATBOT_API_KEY = getattr(settings, "CHATBOT_API_KEY", os.getenv("CHATBOT_API_KEY"))

genai.configure(api_key=CHATBOT_API_KEY)

def ask_gemini(prompt, model="gemini-3-flash-preview"):
    if not CHATBOT_API_KEY:
        return "Error: API key is missing!"

    try:
        # Initialize the model
        gemini_model = genai.GenerativeModel(model)

        # Send the message and get response
        response = gemini_model.generate_content(prompt)

        # Extract and return the text
        return response.text.strip()

    except Exception as e:
        error_message = str(e)

        if "API_KEY_INVALID" in error_message:
            return "Error: Invalid API key. Check your Google AI Studio key."

        elif "QUOTA_EXCEEDED" in error_message:
            return "Error: Quota exceeded. You've hit the free tier limit."

        elif "SAFETY" in error_message:
            return "Error: Message blocked by Gemini safety filters."

        elif "404" in error_message:
            return "Error: Model not found. Try 'gemini-1.5-flash' or 'gemini-pro'."

        else:
            return f"Error: Something went wrong - {error_message}"