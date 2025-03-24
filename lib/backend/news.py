from newsapi import NewsApiClient
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv('NEWS_API_KEY')
newsapi = NewsApiClient(api_key=api_key)

def fetch_news(query=None, 
               sources=None, 
               category=None, 
               language='en', 
               country=None, 
               from_date=None, 
               to_date=None, 
               sort_by=None, 
               page=None, 
               fetch_type=None):
    try:
        if fetch_type == 'top_headlines':
            response = newsapi.get_top_headlines(
                q=query,
                sources=sources,
                category=category,
                language=language,
                country=country,
                page=page
            )
        elif fetch_type == 'everything':
            response = newsapi.get_everything(
                q=query,
                sources=sources,
                from_param=from_date,
                to=to_date,
                language=language,
                sort_by=sort_by,
                page=page
            )
        elif fetch_type == 'sources':
            response = newsapi.get_sources()
        else:
            raise ValueError("Invalid fetch_type. Choose 'top_headlines', 'everything', or 'sources'.")

        return response

    except Exception as e:
        print(f"An error occurred: {e}")
        return None

