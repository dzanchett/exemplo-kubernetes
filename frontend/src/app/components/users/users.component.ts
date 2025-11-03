import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService, User } from '../../services/api.service';

@Component({
  selector: 'app-users',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div>
      <div class="service-info" *ngIf="serviceInfo">
        <div class="status">
          <span class="status-dot"></span>
          <span>{{ serviceInfo.service }} - {{ serviceInfo.status }}</span>
        </div>
        <span>v{{ serviceInfo.version }}</span>
      </div>

      <div class="loading" *ngIf="loading">
        ? Carregando usu?rios...
      </div>

      <div class="error" *ngIf="error">
        ? {{ error }}
      </div>

      <div class="grid" *ngIf="!loading && !error && users.length > 0">
        <div class="card" *ngFor="let user of users">
          <h3>{{ user.name }}</h3>
          <p>?? {{ user.email }}</p>
          <p>?? Fun??o: {{ user.role }}</p>
          <span class="badge">ID: {{ user.id }}</span>
        </div>
      </div>

      <div *ngIf="!loading && !error && users.length === 0">
        <p style="text-align: center; color: #666;">Nenhum usu?rio encontrado.</p>
      </div>
    </div>
  `,
  styles: []
})
export class UsersComponent implements OnInit {
  users: User[] = [];
  loading = true;
  error = '';
  serviceInfo: any = null;

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadServiceInfo();
    this.loadUsers();
  }

  loadServiceInfo(): void {
    this.apiService.getUsersHealth().subscribe({
      next: (data) => {
        this.serviceInfo = data;
      },
      error: (err) => {
        console.error('Erro ao carregar informa??es do servi?o:', err);
      }
    });
  }

  loadUsers(): void {
    this.loading = true;
    this.error = '';

    this.apiService.getUsers().subscribe({
      next: (response) => {
        this.users = response.data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erro ao carregar usu?rios:', err);
        this.error = 'N?o foi poss?vel carregar os usu?rios. Verifique se o servi?o est? rodando.';
        this.loading = false;
      }
    });
  }
}
