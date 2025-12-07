import React, { useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
    const [input, setInput] = useState("");
    const [response, setResponse] = useState("");
    const [isLoading, setIsLoading] = useState(false);
    
    const API_URL = "https://mdsa4geh88.execute-api.us-east-1.amazonaws.com/dev";

    const fetchAIResponse = async () => {
        if (!input.trim()) return;
        setIsLoading(true);
        try {
            const result = await axios.post(
                API_URL+"/",
                { inputText: input },
                {
                    headers: { "Content-Type": "application/json" }
                }
            );
            setResponse(result.data.response);
        } catch (error) {
            console.error("API Error:", error);
            setResponse("Error: " + error.message);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="app-container">
            <h1 className="app-title">TechMobile X100 AI Assistant</h1>
            <div className="input-container">
                <input
                    type="text"
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    placeholder="Ask me anything..."
                    className="input-field"
                    disabled={isLoading}
                />
                <button
                    onClick={fetchAIResponse}
                    className="ask-button"
                    disabled={isLoading}
                >
                    {isLoading ? "Loading..." : "Ask AI"}
                </button>
            </div>
            {response && (
                <div className="response-container">
                    <p className="response-text">{response}</p>
                </div>
            )}
        </div>
    );
}

export default App;