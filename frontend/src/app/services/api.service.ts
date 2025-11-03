import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface User {
  id: number;
  name: string;
  email: string;
  role: string;
  created_at?: string;
}

export interface Product {
  id: number;
  name: string;
  price: number;
  category: string;
  stock: number;
  description?: string;
  created_at?: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  service: string;
  timestamp?: string;
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private usersApiUrl = environment.usersApiUrl;
  private productsApiUrl = environment.productsApiUrl;

  constructor(private http: HttpClient) {}

  getUsers(): Observable<ApiResponse<User[]>> {
    return this.http.get<ApiResponse<User[]>>(`${this.usersApiUrl}/api/users`);
  }

  getUser(id: number): Observable<ApiResponse<User>> {
    return this.http.get<ApiResponse<User>>(`${this.usersApiUrl}/api/users/${id}`);
  }

  getUsersHealth(): Observable<any> {
    return this.http.get(`${this.usersApiUrl}/api/health`);
  }

  getProducts(): Observable<ApiResponse<Product[]>> {
    return this.http.get<ApiResponse<Product[]>>(`${this.productsApiUrl}/api/products`);
  }

  getProduct(id: number): Observable<ApiResponse<Product>> {
    return this.http.get<ApiResponse<Product>>(`${this.productsApiUrl}/api/products/${id}`);
  }

  getProductsHealth(): Observable<any> {
    return this.http.get(`${this.productsApiUrl}/api/health`);
  }
}
