import React, { useState } from 'react';
import axios from 'axios';
import { Database, Terminal, FileText, Activity, LayoutDashboard } from 'lucide-react';
import QueryRunner from './components/QueryRunner';
import TableViewer from './components/TableViewer';
import AuditLogs from './components/AuditLogs';
import Procedures from './components/Procedures';
import Dashboard from './components/Dashboard';
import './App.css';

const API_BASE = 'http://localhost:5000/api';

function App() {
  const [activeTab, setActiveTab] = useState('dashboard');

  const renderContent = () => {
    switch (activeTab) {
      case 'dashboard': return <Dashboard apiBase={API_BASE} />;
      case 'query': return <QueryRunner apiBase={API_BASE} />;
      case 'tables': return <TableViewer apiBase={API_BASE} />;
      case 'procedures': return <Procedures apiBase={API_BASE} />;
      case 'audit': return <AuditLogs apiBase={API_BASE} />;
      default: return <Dashboard apiBase={API_BASE} />;
    }
  };

  return (
    <div className="app-container">
      <nav className="sidebar glass">
        <div className="brand">
          <Database size={24} color="var(--primary-color)" />
          <h2>DBMS Panel</h2>
        </div>
        <ul className="nav-links">
          <li className={activeTab === 'dashboard' ? 'active' : ''} onClick={() => setActiveTab('dashboard')}>
            <LayoutDashboard size={20} /> Dashboard
          </li>
          <li className={activeTab === 'query' ? 'active' : ''} onClick={() => setActiveTab('query')}>
            <Terminal size={20} /> SQL Runner
          </li>
          <li className={activeTab === 'tables' ? 'active' : ''} onClick={() => setActiveTab('tables')}>
            <Database size={20} /> Tables & Views
          </li>
          <li className={activeTab === 'procedures' ? 'active' : ''} onClick={() => setActiveTab('procedures')}>
            <Activity size={20} /> Procedures
          </li>
          <li className={activeTab === 'audit' ? 'active' : ''} onClick={() => setActiveTab('audit')}>
            <FileText size={20} /> Audit Logs
          </li>
        </ul>
      </nav>
      <main className="main-content">
        <header className="top-header glass">
          <h1>University Placement Management System</h1>
          <span className="badge badge-primary">Admin Portal</span>
        </header>
        <div className="content-area animate-fade-in">
          {renderContent()}
        </div>
      </main>
    </div>
  );
}

export default App;
