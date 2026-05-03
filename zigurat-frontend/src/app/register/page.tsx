'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { register } from '@/services/api';
import toast from 'react-hot-toast';
import Link from 'next/link';

export default function RegisterPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    fullName: '',
    passportNumber: '',
    countryOfOrigin: 'IRN',
    phoneNumber: '',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await register(formData);
      toast.success('Registration successful! Please login.');
      router.push('/');
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Registration failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-600 to-blue-400 p-4">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-md p-8">
        <div className="text-center mb-6">
          <h1 className="text-2xl font-bold text-gray-800">Create Account</h1>
          <p className="text-gray-500 mt-2">Join Zigurat International</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <input type="text" placeholder="Full Name" value={formData.fullName} onChange={(e) => setFormData({...formData, fullName: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" required />
          <input type="email" placeholder="Email" value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" required />
          <input type="text" placeholder="Passport Number" value={formData.passportNumber} onChange={(e) => setFormData({...formData, passportNumber: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" />
          <input type="tel" placeholder="Phone Number" value={formData.phoneNumber} onChange={(e) => setFormData({...formData, phoneNumber: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" />
          <select value={formData.countryOfOrigin} onChange={(e) => setFormData({...formData, countryOfOrigin: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="IRN">Iran</option><option value="IRQ">Iraq</option><option value="AFG">Afghanistan</option>
            <option value="PAK">Pakistan</option><option value="CHN">China</option><option value="SYR">Syria</option>
          </select>
          <input type="password" placeholder="Password" value={formData.password} onChange={(e) => setFormData({...formData, password: e.target.value})} className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" required />
          <button type="submit" disabled={loading} className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 rounded-lg transition">{loading ? 'Registering...' : 'Register'}</button>
        </form>

        <div className="mt-6 text-center text-sm">
          Already have an account? <Link href="/" className="text-blue-600 hover:underline">Login</Link>
        </div>
      </div>
    </div>
  );
}
