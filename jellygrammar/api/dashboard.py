from __future__ import annotations
from pydantic import BaseModel, Field
from typing import Union, List
from uuid import uuid4
from datetime import datetime
from google.cloud import firestore
import logging
import functions_framework


# Constants
GCP_PROJECT_ID = ''
GCP_FIRESTORE_DATABASE = 'capstone-grammar'
GCP_FIRESTORE_USER_DASHBOARD_COLLECTION = 'user_dashboard'


# Initialize Firestore Client
firestore_client = firestore.Client(database=GCP_FIRESTORE_DATABASE)
logger = logging.getLogger(__name__)


class UserDashboard(BaseModel):
    uid: Union[str, None] = Field(None, title="User ID", description="The unique identifier for the user")
    reset_timestamp: Union[float, None] = Field(None, title="Reset Timestamp", description="The timestamp of the last reset")
    max_requests: int = Field(10, title="Max Requests", description="The maximum number of requests allowed")
    cur_requests: int = Field(0, title="Current Requests", description="The current number of requests")
    request_desc: str = Field("Remaining Analysis Requests", title="Request Description", description="The description of the request")
    reset_desc: str = Field("Next Reset", title="Reset Description", description="The description of the reset")

    def to_dict(self):
        return {
            "uid": self.uid,
            "reset_timestamp": self.reset_timestamp,
            "max_requests": self.max_requests,
            "cur_requests": self.cur_requests,
            "request_desc": self.request_desc,
            "reset_desc": self.reset_desc
        }
    
    @classmethod
    def from_dict(cls, data) -> UserDashboard:
        return cls(
            uid=data.get('uid'),
            reset_timestamp=data.get('reset_timestamp'),
            max_requests=data.get('max_requests'),
            cur_requests=data.get('cur_requests'),
            request_desc=data.get('request_desc'),
            reset_desc=data.get('reset_desc')
        )

    def to_firestore(self):
        user_dashboard_ref = firestore_client.collection(GCP_FIRESTORE_USER_DASHBOARD_COLLECTION).document(self.uid)
        user_dashboard_ref.set(self.to_dict())

    @classmethod
    def from_firestore(cls, uid: str) -> UserDashboard:
        try:
            user_dashboard_ref = firestore_client.collection(GCP_FIRESTORE_USER_DASHBOARD_COLLECTION).document(uid)
            user_dashboard_data = user_dashboard_ref.get()
            return cls.from_dict(user_dashboard_data.to_dict())
        except Exception as e:
            logger.error(f"Error fetching user dashboard data: {e}")
            return None

    def _check_request_quota(self):
        current_timestamp = datetime.now().timestamp()
        if self.reset_timestamp is None:
            self.cur_requests = 0
            self.reset_timestamp = datetime.now().timestamp()
        elif current_timestamp - self.reset_timestamp > 86400: # 24 hours
            self.cur_requests = 0
            self.reset_timestamp = current_timestamp + 86400
        else:
            logger.info("Quota already reset for the day")


def init_user_dashboard(request, headers):
    # Get the User ID from query parameter
    request_args = request.args # query params
    uid = request_args.get('user', str(uuid4()))
    user_dashboard = UserDashboard(uid=uid)
    user_dashboard._check_request_quota()
    user_dashboard.to_firestore()
    return user_dashboard.to_dict(), 200, headers


def get_user_dashboard(request, headers):
    # Get the User ID from the path parameter
    request_args = request.args # query params
    uid = request_args.get('user', None)
    
    if uid is None:
        return {'error': 'User ID not provided'}, 400, headers

    user_dashboard = UserDashboard.from_firestore(uid=uid)
    
    if user_dashboard is None:
        return {'error': 'User not found'}, 404, headers
        
    return user_dashboard.to_dict(), 200, headers


@functions_framework.http
def main(request):
    """ Main API
    """
    # Set CORS headers for the preflight request
    if request.method == "OPTIONS":
        # Allows GET requests from any origin with the Content-Type
        # header and caches preflight response for an 3600s
        headers = {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Max-Age": "3600",
        }

        return ("", 204, headers)

    # Set CORS headers for the main request
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Max-Age": "3600",
    }

    if request.method == "POST":
        return init_user_dashboard(request, headers)
    elif request.method == "GET":
        return get_user_dashboard(request, headers)
    else:
        return {"error": "Method not allowed"}, 405, headers